Title: AWS SSO
Date: 2022-05-10 21:17
Tags: dev
Slug: aws sso
Author: Feng Xia

[AWS SSO][2] is a pretty interesting idea. It's actually a bit confusing
when I first touched it, namely,

1. What is a profile
2. How to setup a profile
3. How to use a profile

The [article][1] has good explanation on the concept. I'm gonna quote
it here so I don't need to reinvent the wheels.

# What is SSO login

> With AWS SSO, you log in as a human, and the token you receive that
> represent you as a logged-in human can become any of the various IAM
> roles in the various accounts that they have been granted access
> to. Even though you give a profile in the input to aws sso login, the
> resulting session is not scoped to the account and role in that
> profile, by design. In the browser, when you log in through your AWS
> SSO start URL (in this case, https://foo.awsapps.com/start), you are
> logged in for all your access, and can find the account and role and
> clicking through it to get into the AWS web console. When you want to
> switch between accounts and roles, you don't need to log in
> again; you go back to the start page and click through into the
> console as a different account and role. In the CLI, it works the same
> way, you log in as a human using aws sso login, and this permits you
> to use any of the accounts and roles you have access to without
> logging in again.
>

The curious thing is, in order do the SSO login, you **must have** at
least one profile! Read on.


# What is a profile

> A profile configured in ~/.aws/config that is not using IAM User
> credentials does not represent a particular human. It represents a
> role that any human with the right permissions may assume, and should
> be named accordingly. The profile is about the activities those
> credentials enable, not who may be performing those activities. A
> profile configured for AWS SSO includes the AWS SSO instance (the
> start URL and the region that AWS SSO is configured in), the account,
> and the role in that account to use, when logged in through AWS SSO as
> some human (and will work only if that human has been granted access
> to that account and role through AWS SSO).
>

A hypothetical profile in `~/.aws/config` looks something like this:

```
[profile AcctA-Role1]
sso_start_url = https://foo.awsapps.com/start
sso_region = us-east-2
sso_account_id = 111122223333
sso_role_name = Role1

[profile AcctB-Role2]
sso_start_url = https://foo.awsapps.com/start
sso_region = us-east-2
sso_account_id = 777788889999
sso_role_name = Role2

[profile AcctB-Role1]
sso_start_url = https://foo.awsapps.com/start
sso_region = us-east-2
sso_account_id = 777788889999
sso_role_name = Role1
```

In order to do the SSO login in previous section, you must have **at
least one profile**, let's call it the `default` profile:

```
[profile default]
sso_start_url = https://foo.awsapps.com/start
sso_region = us-east-2
```

It only needs the `start_url` and a `region`. With this you so `aws
sso login --profile default`, and complete the login process.


# How to setup a profile

Three ways: copy & paste directly to `~/.aws/config` (at least for the
`default` one, this is the easiest way!), go through `aws sso
configure`, or using `aws-sso-util`.

## Use `aws sso configure`

1. You use `aws sso configure` to setup a profile. **Note** that you
   can also just copy and paste to `~/.aws/config` directly if you
   know what you are doing.

        ```shell
        fengxia@fl5wvhzxat:~/aws$ aws configure sso
        SSO start URL [None]: <https://d-<.....>.awsapps.com/start>
        SSO Region [None]: us-east-1
        There are 12 AWS accounts available to you.
        Using the account ID <......>
        The only role available to you is: ReadOnly
        Using the role name "ReadOnly"
        CLI default client Region [None]: us-east-1
        CLI default output format [None]: json
        CLI profile name [ReadOnly-<account id>]: give-it-a-name
        ```

2. Now use the profile to login: `aws sso login --profile <your
   profile>`. Click the `Allow` on the browser.

3. Get credential(!). This is a step easily omitted, and is exactly
   the warning above is about. Login only gets you the _I'm a human_
   proof, but the computer doesn't yet have credential (actually a
   short-life token) to run all the followup calls. Thus you need to
   **acquire** profile's credential:

        ```shell
        aws sts get-caller-identity --profile SaaS-Dev.Administrator
        ```

    Expect to see an output like this:

         ```json
         {
             "UserId": "xxxxxxx:feng.xia@lucidum.io",
             "Account": "xxxxxx",
             "Arn": "arn:aws:sts::xxxxxxx:assumed-role/AWSReservedSSO_Administrator_xxxxxx/<email>"
         }
         ```

4. Now you are ready to launch CLI that will bear the AWS profile you
   choose and have access to the resources this profile is allowed to.

## Use `aws-sso-util` for batch

It's ok to use the manual way for one profile. But in practice you may
be granted permission on a list of profiles. Use [aws-sso-util][3] to
populate all the profiles you can have:

```shell
aws-sso-util configure populate \
  --region us-west-1 \
  --existing-config-action keep
```

This will enumerate through your AWS access to grab all profiles you
can have, and dump them into the `~/.aws/config`. From that point on,
you just pick one and use it.

# How to use a profile

Now I have logged in, what if I have multiple profiles defined? Can I
switch between them freely? &mdash; pretty much, but read this common
_misunderstanding_ first!!!

> I have seen people get the impression that if they want to use Role1
> in account A (111122223333), they need to call aws sso login --profile
> AcctA-Role1, and that if they subsequently want to use Role2 in
> account B (777788889999), they need to then call aws sso login
> --profile AcctB-Role2. However, this isn't how AWS SSO or the
> CLI works!
>
> What's critical to note is that aws sso login does not deal
> with accounts or roles at all! You can see the code here; it uses the
> start URL and SSO region only. After calling aws sso login --profile
> AcctA-Role1, there are no credentials for Role1 in account A on your
> system.
>

Using a profile is essentially to run a CLI within the context of a
profile. Two tools, [aws-vault][4] and [aws2-wrap][5]. Both
essentially do the same thing. My experience is better w/
[aws2-wrap][5] than [aws-vault][4], so I'll use that for illustration.

```shell
aws2-wrap --profile=SaaS-Dev.Administrator \
  aws organizations list-accounts
```

Basically any AWS CLI will be executed by the profile you want to
use. Success of the CLI is controlled by whether this profile has the
permission or not.

[1]: https://ben11kehoe.medium.com/you-only-need-to-call-aws-sso-login-once-for-all-your-profiles-41a334e1b37e

[2]: https://aws.amazon.com/single-sign-on/
[3]: https://github.com/benkehoe/aws-sso-util
[4]: https://github.com/99designs/aws-vault
[5]: https://github.com/linaro-its/aws2-wrap
