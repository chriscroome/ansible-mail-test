# Ansible Mail Test

This repo demonstrates that the `Reply-To` header can only be set if the character set of the email is `US-ASCII` when using the [Ansible Mail module](https://docs.ansible.com/ansible/latest/modules/mail_module.html).

Clone this repo and then run the bash script with the first argument being a remote server with Exim set to accept email from local users, you will be prompted for an email addess to send the mail to:

```bash
./mail.sh server.example.org
Email address to send to: you@example.org
```

It will then prompt you for an email address and it will then attempt to sent 2 emails to you:

1. A US-ASCII email with the header `Reply-To=test@example.org`
3. A UTF-8 email with the header `Reply-To=test@example.org`

The first email will work, the second email and third emails will fail with:

```
TASK [mail : UTF-8 Email sent to you@example.org] ******************************************************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: SMTPDataError: (550, 'header syntax')
fatal: [server.example.org]: FAILED! => {"changed": false, "msg": "Failed to send mail to 'you@example.org': (550, 'header syntax')", "rc": 1}
...ignoring

```

The Exim logs on the server this failures:

```
2019-06-29 11:03:20.784 [10043] 1hhB8a-0002bz-OP H=localhost (server.example.org) [127.0.0.1]:50190 I=[127.0.0.1]:25 F=<root@server.example.org> rejected after DATA: header syntax (unqualified address not permitted: failing address in "Reply-To:" header is: =?utf-8?q?test=40example=2Eorg?=): unqualified address not permitted: failing address in "Reply-To:" header is: =?utf-8?q?test=40example=2Eorg?=
```
