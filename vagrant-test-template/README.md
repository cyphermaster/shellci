# shellci

### Vagrant test template

Vagrant test template shows how to create a new throw-away VM, execute dev-stack and finally run tempest tests.
You can customize the dev-stack and the tempest tests modifying the files local.conf.template and inside-vagrant.sh.

To test it, just run:
```
cp local.conf.template local.conf
./runVM.sh
```

