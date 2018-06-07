Title: Charm Ansible integration
Date: 2017-07-06 13:00
Tags: lenovo
Slug: charm ansible integration
Author: Feng Xia

Let's face it. Ansible has the mouth (and market) share these
days. For our modeling purpose, we are to utilize its procedural
strength to carry out actions, which provides an abstraction instead
of coding in charm's Python files.

Design objectives:

1. Design as reusable [layer(s)][1]
2. Be compatible with Ubuntu and CentOS
3. Simple pattern to execute a playbook

[1]: https://jujucharms.com/docs/2.1/developer-layers

Assumption:

1. Playbooks will be local (in charm) so to maintain the
   atomic nature of a HW charm &mdash; the model contains both the
   declaration of attributes and actions to handle runtime state transitions.

# Method 1: layer-ansible

Method 1 is to use an existing project, [layer-ansible][2].

[2]: https://github.com/chuckbutler/charms.ansible

Examine its code reveals a typical pattern one would use to introduce
a new function:

1. Install Ansible. The approach it took is to use a
   `ppa:ansible/ansible` source and installed by calling
   `charmhelpers.fetch.apt_install`. The key issue here is using `ppa`
   which is an **hardcoded** Ubuntu approach.

        ```python
        def install_ansible_support(from_ppa=True, ppa_location='ppa:ansible/ansible'):
          if from_ppa:
              charmhelpers.fetch.add_source(ppa_location)
              charmhelpers.fetch.apt_update(fatal=True)
          charmhelpers.fetch.apt_install('ansible')
          with open(ansible_hosts_path, 'w+') as hosts_file:
              hosts_file.write('localhost ansible_connection=local')
        ```

2. Helper function to execute. Clearly the approach here is to use
   `subprocess.check_call` which is calling `ansible-playbook` as
   CLI. This works fine but then think about all the CLI switches that
   `ansible-playbook` can take which in turn need to be exposed
   through this function &larr; currently it supports `tags` and `extra-vars`.

        ```python
        def apply_playbook(playbook, tags=None, extra_vars=None):
            ....
            call = [
                'ansible-playbook',
                '-c',
                'local',
                playbook,
            ]
            if tags:
                call.extend(['--tags', '{}'.format(tags)])
            if extra_vars:
                extra = ["%s=%s" % (k, v) for k, v in extra_vars.items()]
                call.extend(['--extra-vars', " ".join(extra)])
            subprocess.check_call(call, env=env)
        ```

A nice feature of this library is the implementation of [hooks][3] and
[actions][4] so that Ansible can answer to `hook` event and can be
executed as `action`.

[3]: https://jujucharms.com/docs/stable/authors-charm-hooks
[4]: https://jujucharms.com/docs/stable/actions

# Method 2: layer-myansible

This method is inspired by [this article][5]. This is to take
advantage of the [Ansible Python API][6]. 

[5]: https://serversforhackers.com/running-ansible-2-programmatically
[6]: http://docs.ansible.com/ansible/dev_guide/developing_api.html

1. Install prerequisites. Installing `Ansible` will fail on a vanilla
   Ubuntu because it misses a few dependencies. Using [layer-basic][7]
   by listing them out in `layer.yaml`:

       ```yaml
        includes:
          - 'layer:basic'
        options:
          basic:
            packages:
              - libffi-dev
              - libssl-dev
              - python
              - python3-dev
       ```

[7]: https://github.com/juju-solutions/layer-basic

2. Install Ansible.  Use Python [wheel][8] supported
   by [layer-basic][7]. In `wheelhouse.txt`:

[8]: https://packaging.python.org/discussions/wheel-vs-egg/?highlight=wheel

        ```shell
        ansible==2.2.0
        ```

3. `ansible.cfg`. Instead of using a global config, this is local so
   each charm can have its own variation if desired.

        ```shell
        [defaults]
        inventory = ./hosts
        log_path = /var/log/ansible/ansible.log
        remote_tmp = $HOME/.ansible/tmp
        local_tmp = $HOME/.ansible/tmp
        [ssh_connection]
        ssh_args = -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s
        control_path = ~/.ansible/cp/ansible-ssh-%%h-%%p-%%r
        ```

4. Options. Constructed a class to be the abstraction of Ansible
   options:

        ```python
        class Options(object):
            """
            Options class to replace Ansible OptParser
            """
            ....
            verbosity=None,
            inventory=None,
            listhosts=None,
            subset=None,
            module_paths=None,
            extra_vars=None,
            forks=None,
            ask_vault_pass=None,
            vault_password_files=None,
            new_vault_password_file=None,
            output_file=None,
            tags=None,
            skip_tags=[],
            one_line=None,
            tree=None,
            ask_sudo_pass=None,
            ask_su_pass=None,
            sudo=None,
            sudo_user=None,
            become=None,
            become_method=None,
            become_user=None,
            become_ask_pass=None,
            ask_pass=None,
            private_key_file=None,
            remote_user=None,
            connection=None,
            timeout=None,
            ssh_common_args=None,
            sftp_extra_args=None,
            scp_extra_args=None,
            ssh_extra_args=None,
            poll_interval=None,
            seconds=None,
            check=None,
            syntax=None,
            diff=None,
            force_handlers=None,
            flush_cache=None,
            listtasks=None,
            listtags=[],
            module_path=None
        ```

5. Playbook execution. Running it is to use
   Ansible's API call `PlaybookExecutor`.

        ```python
        self.pbex = playbook_executor.PlaybookExecutor(
            playbooks=pbs,
            inventory=self.inventory,
            variable_manager=self.variable_manager,
            loader=self.loader,
            options=self.options,
            passwords=passwords)
        ....
        self.pbex.run()
        ```

# Charm integration

Using `layer-myansible` for example, integrating with charm takes the
followings:

1. Include layer. In `layer.yaml`:

        ```yaml
        includes:
          - 'layer:basic'
          - 'layer:myansible'
        ```

2. Create a `playbooks` folder and place playbooks here:

        ```shell
        .
        ├── config.yaml
        ├── icon.svg
        ├── layer.yaml
        ├── metadata.yaml
        ├── playbooks
        │   └── test.yaml
        └── reactive
            └── solution.py
        ```

3. Using `config.yaml` to pass in playbook for each action that is
   defined in the charm states. For example, define `test.yaml` for an
   action in `state-0`:

        ```yaml
        options:
          state-0-playbook:
            type: string
            default: "test.yaml"
            description: "Playbook for..."
        ```

4. Define the playbook. For example, a _hello world_ that will create
   a file `/tmp/testfile.txt'.

        ```yaml
        - name: This is a hello-world example
          hosts: 127.0.0.1
          tasks:
          - name: Create a file called '/tmp/testfile.txt' with the content 'hello world'.
            copy: content="hello world\n" dest=/tmp/testfile.txt
            tags:
              - sth
        ```

    Note that `tags` value `sth` must match playbook run call (see
    below).

5. In charm `.py` file, `from charms.layer.task import Runner`, then
   in `state-0` to call given playbook:

        ```python
        playbook = config['state-0-playbook']
        runner = Runner(
            tags = 'sth', # <-- must match the tag in the playbook
            connection = 'local', # <-- must be "local"
            hostnames = '127.0.0.1', # <-- assuming execution in localhost
            playbooks = [playbook],
            private_key_file = '',
            run_data = {},
            become_pass = '',
            verbosity = 0
        )
        stats = runner.run()
        ```

That's it. Now you can build a charm by including `layer-myansible`
and run any playbooks in your charm by following this design pattern
while taking full advantage of the [Ansible Python API][6]. Beautiful.
