
# basic obsidian sync

## what
a REALLY simple setup for syncing your obsidian
if youre a dev and have git setup, feels nice to sync your notes into a PRIVATE repo

## why
i tried the [obsidian git community plugin](https://github.com/denolehov/obsidian-git) but it wasn't working for me.
also that uses git.js or so, and apparently cant use ssh auth, which you should be doing.
so i thought its simple enough for a bash script to commit & push regularly


## instructions
setup
1. setup git cli w ssh keys
2. download repo & open folder as vault in obsidian
3. test
4. setup cron job or other

## 3. test 
test run script in terminal
will check for changes & commit
every 3rd run it will push
`./sync.sh master 3`
( see output or ask [ai](https://huggingface.co/chat/) if it's not working )

## 4. cron
`crontab -e` to setup cron job
add cron command as you wish

```
# cron job that runs every 6 minutes, pushing every 3rd run & logs to file
*/6 * * * * ~/obsidiary/sync.sh master 3 log
```

## 
this will create a hidden `.counter` in order to push every X iterations