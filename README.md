# drupal-orb

This orb provides standard jobs for PNX workflows. It assumes you have a Makefile with a number
of tasks defined. See each job for a description.

## Resources
[CircleCI Orb Registry Page](https://circleci.com/orbs/registry/orb/pnx/drupal) - The official registry page of this orb for all versions, executors, commands, and jobs described.
[CircleCI Orb Docs](https://circleci.com/docs/2.0/orb-intro/#section=configuration) - Docs for using and creating CircleCI Orbs.

## Known Issues

You may get this error when pushing a new PR,

```
The dev version of pnx/drupal@dev:alpha has expired. Dev versions of orbs are only valid for 90 days after publishing.
```

If you see this error, you need to publish a dev:alpha version manually. The fix is to run this:

```
circleci orb pack ./src | circleci orb validate -
circleci orb pack ./src | circleci orb publish -  pnx/drupal@dev:alpha
```
