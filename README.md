# Check Postfix queue

This is a simple postfix queue checking script. Just run it, indicating as a parameter the threshold value beyond which the e-mails in the queue must not going on

```bash
./check-postfix-queue.sh 30
```

If the threshold value is exceeded, the script will send an alert email with the details of the queue, like this

![](https://github.com/Ivanhoe-wq/check-postfix-queue/blob/main/screenshot.jpg)

## Install

Download lo script on your server and set up a cron job, run

```bash
crontab -e
```

And insert line like this

```bash
*/15 * * * * /root/bin/check_postfix_queue.sh 50 >> /var/log/check.log 2>&1
```

then edit the script to insert the email to which to send the alerts

```bash
vim /root/bin/check_postfix_queue.sh
```

edit RECIPIENT var
