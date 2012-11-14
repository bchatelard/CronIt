#CronIt is a simple tool to run locally some scrips.

It use whenever to register script in crontab.

Just add some script in `scripts` directory and run whenever.

You need to inherit from CronIt, then use the `every` macro to register
the interval time.
```
  every :day, :at => '4:30 am'
  every 2.minutes
```

And register a new callback with `run`:
```
  run :launch
```
Everytime cron trigger your module, it will initalize the objet and run
the `launch` function.
