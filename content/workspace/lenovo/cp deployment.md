Title: ThinkAgile CP Deployment
Date: 2019-10-02 13:24
Tags: lenovo
Slug: cp deployment
Author: Feng Xia
Status: Draft

Follow these instructions to deploy a ThinkAgile CP stack.

# Prerequisite

1. Stacks have been cabled.
2. Network planning worksheet has been filled out.
3. Uplink switches have been configured according the worksheet.
4. Connect a bootstrap (Linux) machine, eg. your laptop, with a serial
   to USB adapter cable. Serial cable is connected to the primary
   interconnect.
   
# Bootstrap

On Ubuntu 18.04, 

1. `sudo screen /dev/ttyUSB0 115200 cs8`, wait for prompt `XorPlus
   login:`. Now you are connected to the primary interconnect.
   
     - login: (manager, cloudistics)
   
2. Setup uplink IP, DNS server, and NTP server:


        ```shell
        sudo cldtx_set_switch_oob_ip -v <oob vlan> \
          -i <oob ip> \
          -m <oob netmask> \
          -g <oob gateway> \
          -n <primary DNS server, default to 8.8.8.8> \
          -d <2nd DNS server, default to 8.8.4.4> \
          -t <primary NTP server, default to "time1.google.com"> \
          -p <2nd NTP server, default to "time2.google.com">
        ``` 

    Example output:
    
        ```shell
        Execute command: 
                          set system management-ethernet eth0 ip-gateway IPv4 10.240.22.1.
        The same value is set to node "system management-ethernet eth0 ip-gateway IPv4".
        root@XorPlus# 
        Execute command: 
                          commit.
        Commit OK.
        root@XorPlus# 
        Execute command: 
        .
        root@XorPlus# 
        Synchronizing configuration...OK.
        Pica8 PicOS Version 2.11.5.cloudistics.1
        Welcome to PicOS on XorPlus
        root@XorPlus> 
        Execute command: configure.
        Entering configuration mode.
        There are no other users in configuration mode.
        root@XorPlus# 
        Execute command: delete system dns-server-ip 8.8.8.8^M.
        Deleting: 
            8.8.8.8

        OK 
        root@XorPlus# 
        Execute command: commit 
        .
        Commit OK.
        Save done.
        root@XorPlus# 
        Synchronizing configuration...OK.
        Pica8 PicOS Version 2.11.5.cloudistics.1
        OK 
        root@XorPlus# 
        Execute command: commit 
        .
        Commit OK.
        Save done.
        root@XorPlus# 
        Synchronizing configuration...OK.
        Pica8 PicOS Version 2.11.5.cloudistics.1
        Welcome to PicOS on XorPlus
        root@XorPlus> 
        Execute command: configure.
        Entering configuration mode.
        There are no other users in configuration mode.
        root@XorPlus# 
        Execute command: set system dns-server-ip 8.8.8.8.
        root@XorPlus# 
        Execute command: commit
        .
        Commit OK.
        Save done.
        root@XorPlus# 
        Synchronizing configuration...OK.
        Pica8 PicOS Version 2.11.5.cloudistics.1
        Welcome to PicOS on XorPlus
        root@XorPlus> 
        Execute command: configure.
        Entering configuration mode.
        There are no other users in configuration mode.
        root@XorPlus# 
        Execute command: set system dns-server-ip 8.8.4.4.
        root@XorPlus# 
        Execute command: commit
        Synchronizing configuration...OK.
        Pica8 PicOS Version 2.11.5.cloudistics.1
        Welcome to PicOS on XorPlus
        root@XorPlus> 
        Execute command: configure.
        Entering configuration mode.
        There are no other users in configuration mode.
        root@XorPlus# 
        Execute command: set system dns-server-ip 8.8.8.8.
        root@XorPlus# 
        Execute command: commit
        .
        Commit OK.
        Save done.
        root@XorPlus# 
        Synchronizing configuration...OK.
        Pica8 PicOS Version 2.11.5.cloudistics.1
        Welcome to PicOS on XorPlus
        root@XorPlus> 
        Execute command: configure.
        Entering configuration mode.
        There are no other users in configuration mode.
        root@XorPlus# 
        Execute command: set system dns-server-ip 8.8.4.4.
        root@XorPlus# 
        Execute command: commit
        .
        Commit OK.
        Save done.
        root@XorPlus# 
        Stopping NTP server: ntpd.
        Starting NTP server: ntpd.
        Checking connectivity to host:   port: 
        Cloudistics Portal connection check failed    
        ```

# mwc wildfly local dev

## anaconda

[Official instruction][1].

1. install system packages:

        ```shell
        apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
        ```

2. download [installer][2].

3. `source ~/.bashrc`. If you are curious, this is what that
   initialization step put in this file:
   
        ```shell
        __conda_setup="$('/home/fengxia/anaconda2/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "/home/fengxia/anaconda2/etc/profile.d/conda.sh" ]; then
                . "/home/fengxia/anaconda2/etc/profile.d/conda.sh"
            else
                export PATH="/home/fengxia/anaconda2/bin:$PATH"
            fi
        fi
        unset __conda_setup
        ```

4. `conda -version`. You should see sth like `conda 4.7.10`.

5. `conda config --add channels conda-forge`.

6. `conda create -n mwc_scripts python=2.7 psycopg2 sqlparse
   cassandra-driver`. This message `Collecting package metadata
   (current_repodata.json):` will take a while to complete. Be
   patient. You can execute this multiple times, which `conda` is
   smart enough to ask whethe you want to scratch the virtual env
   `mwc_script` and rebuild it. Further, `pip install` will not
   install the package properly even though `which pip` shows you are
   using the virtulenv's one.

## docker & docker-compose

1. Just follow [this][3].
2. `sudo usermod -a -G docker $USER`, then exit SSH and login again.
3. `docker run hello-world` as test.
4. `apt install docker-compose`.

## mwc

Anything in `.sh`, you have the option to execute them manually, line
by line.

1. In `.bashrc`, append to the end:

        ```shell
        export CLDTX_HOME=/home/<you>/workspace/ignite
        export CLDTX_CONFIG=/etc/cloudistics
        export PYTHON_HOME=/home/<you>/anaconda2
        ```
        
    This is critical because following `.sh` will all be referencing
    these variable values. Worse comes to worst, just run the contents
    of the `.sh` manually.
    
2. Make `/etc/cloudistics` and set permissions:

        ```shell
        # They initialize configuration and database directories.
        sudo mkdir -p /etc/cloudistics
        sudo chown -R "$USER" /etc/cloudistics
        echo 'export CLDTX_CONFIG=/etc/cloudistics' >> ${bashrcHome}
        sudo mkdir -p /temp
        sudo chown -R "$USER" /temp
        ```
3. `source ~/.bashrc`.

4. `mwc/maintenance/unix/setup/init-mwc-builder.sh`. This will build
   docker images.

        ```bash
        #!/bin/bash

        # Create mwc-builder container for building MWC.
        docker build --file "${CLDTX_HOME}/mwc/docker/Dockerfile.dev" --tag mwc-builder "${CLDTX_HOME}/mwc/docker"

        # Create a Docker volume for caching Maven dependencies.
        docker volume create maven-cache
        ```

5. `mwc/maintenance/unix/setup/init-config.sh`.

        ```bash
        #!/bin/bash

        # Copy notification configuration file to /etc/cloudistics directory.
        cp "${CLDTX_HOME}/deployment/management/notifications/notification.rc.json" "${CLDTX_CONFIG}"

        # Copy configuration properties to /etc/cloudistics directory.
        cd "${CLDTX_HOME}/mwc/src/main/resources/"
        cp *.xml "${CLDTX_CONFIG}"
        cp *.properties "${CLDTX_CONFIG}"
        ```

6. Go to `mwc/docker` and spin up database: `docker-compose up -d
   postgres scylla`.

7. Append "host all all 0.0.0.0/0 trust" to
   `/var/lib/docker/volumes/docker_postgres-data/_data/pg_hba.conf`.
   
8. Restart PG2: `docker-compose restart postgres scylla`

9. Init database w/ data: `mwc/maintenance/unit/setup/init-database.sh`

        ```bash
        #!/bin/bash

        # Copy management database migrations that are temporarily in a 
        # "management_changes" file until they are given a number in master.
        cp "${CLDTX_HOME}/db-mgmt/management_changes.sql" "${CLDTX_HOME}/db-mgmt/migrations.d/111111111.sql"

        # Reset the Postgres database.
        "${PYTHON_HOME}/envs/mwc_scripts/bin/python" "${CLDTX_HOME}/db-mgmt/perform_database_migration.py" --db_host localhost --db_port 5432 --db_user_name cldtx --db_user_password cldtx --db_init --db_init_mwc_test_data

        # Remove the temporary management database migration script.
        rm -f "${CLDTX_HOME}/db-mgmt/migrations.d/111111111.sql"

        # Copy stats database migrations that are temporarily in a "management_changes" 
        # file until they are given a number in master.
        cp "${CLDTX_HOME}/db-stats/management_changes.cql" "${CLDTX_HOME}/db-stats/migrations.d/111111111.cql"

        # Reset the Cassandra database.
        "${PYTHON_HOME}/envs/mwc_scripts/bin/python" "${CLDTX_HOME}/db-stats/perform_database_migration.py" --db_init

        # Remove the temporary stats database migration script.
        rm -f "${CLDTX_HOME}/db-stats/migrations.d/111111111.cql"

        ```

10. Launch mwc: `docker-compose up -d wildfly`

# Build webapp (Angular) code locally

1. Install [`nvm`](https://github.com/nvm-sh/nvm)

        ```shell
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
        ```
2. Check `.bashrc` for the snippets below, then `source ~/.bashrc` to load NVM env.

        ```shell
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

        ```

3. Install node: `nvm install node` will pull down the latest. You can
   also specify version, eg. `nvm install 8.0.0`.

   1. To check which version you have: `nvm list`.
   2. To use a version: `nvm use 8.0.0`.

4. Install/upgrade npm: `npm install npm@latest -g`

5. Go to `mwc/src/main/webapp`, and `npm install`. This will take a
   while and create `/node_modules` folder. **Note**: the version it
   installs changes each time, and is also depending on the node
   version selected. So to run different version of node, just delete
   the `node_modules` folder and `npm install` from scratch.

6. Set MWC instance. Edit `webpack-dev.config.js` and replace `target`
   to a MWC instance (the Java middleware this frontend instance will
   be using):

        ```javascript
        proxy: {
          '/': {
            target: "http://<your mwc ip>:8080" // common dev
          }

        ```

    A few common values for the MWC instance:

    1. LTCT lab instance: `http://cldtx-build.labs.<company>.com:8080`,
       internal use only.
    2. Local dev instance: `http://<your IP>:8080`, if you are running
       a local MWC docker on your machine.

7. Run `npm start` should compile w/o error and opens a
   `localhost:3000` on your default browser.

## Hot reloading

`webpack dev server` will auto compile code upon a detected file
`webpack-dev.config.js` for details.
change and refresh browser window. See settings in

On Linux, you need to check system watcher value (see [bug][4]) and
increase it if hot reloading is not working.

```
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

### hot reload does not cover

1. images in `app/share/images`.
2. any `.jsp`
3. setting `js` files such as `webpack-<...>.js`.

You have to rebuild MWC's `.war`, then relaunch the `wildfly`
container to see the effect. Therefore, it's necessary to have a local
MWC build env and change the `webpack-dev.config.js` dev server to
your local instance for dev & test in these cases.

## Development conventions

1. Tab width: 2, for `.html`, `.ts`, `.js`, `.scss`.
2. HTML attributes should be one-per-line, and they should line up:

        ```html
        <div class="navbar-header">
          <a class="navbar-brand on-hover-show-text-bg-child-elements"
             ui-sref="auth.authentication.login">
            <img src="/app/shared/images/lenovologo-pos-red-vertical.png"
                 class="inline">
          </a>
        </div>
        ```
3. Never use inline style in HTML.
4. When changing `.scss`, search all `.html` to know the side effect.
5. Merge request of HTML changes should update `/doc` including such
   as screenshot.

# Knowledge

## Usage of `webapp/public-marketplace/src/assets/icons`

1. android-chrome-192x192.png, android-chrome-512x512.png and apple-touch-icon

   Used in manifest.json in the same directory. To quote, "The web app
   manifest is a simple JSON file that tells the browser about your web
   application and how it should behave when 'installed' on the user's
   mobile device or desktop.".

   In order to test those icons, we can use chrome dev tools
   (Application - Manifest)

   To learn more about this topic, check the following links: [Mozilla
   docs][5] ,[Google docs][6].

2. favicon-16x16.png, favicon-32x32.png, favicon.ico

   Used to set the favicon for the website. This can be checked easily,
   look at the icon shown on the browser tab where the portal is opened

3. mstile-70x70.png, mstile-144x144png, mstile-150x150.png,
   mstile-310x150.png,mstile-310x310.png

   Used in browserconfig.xml in the same directory. As we can learn
   more in [this][7], those icons are used when we pin a website in
   windows (Start menu or taskbar)

   The easiest way to test this is using Edge Browser. Navigate to the
   portal, click the 'three dots' option in the top right corner and
   select where you want the website to be pinned.

[1]: https://docs.anaconda.com/anaconda/install/linux/
[2]: https://www.anaconda.com/download/#linux
[3]: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
[4]: https://github.com/webpack/webpack-dev-server/issues/724
[5]: https://developer.mozilla.org/en-US/docs/Web/Manifest
[6]: https://developers.google.com/web/fundamentals/app-install-banners/
[7]: https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/dn320426(v=vs.85)?redirectedfrom=MSDN
