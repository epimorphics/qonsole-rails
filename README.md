# qonsole-rails

A version of the [SPARQL qonsole](https://github.com/epimorphics/qonsole) that
runs as a Rails engine

> [!CAUTION]
> While this project has not yet been replaced and should continue
> to receive required bug fixes and any minor feature requests, future
> development of qonsole will be done as part of the
> [qonsole-sfc](https://github.com/epimorphics/qonsole-sfc) project.
> (2022-07-04)

> [!IMPORTANT]
> Gem dependencies are now recorded BOTH in the Gemfile, AND in the .gemspec,
> due to a "quirk" with the `bundler outdated` utility not checking gems listed
> in the .gemspec while running the `make update` target command which uses the
> `--only-explicit` flag[^1].

> [!CAUTION]
> Please be sure to mirror manual version updates to both locations.

[^1]: <https://bundler.io/man/bundle-outdated.1.html>

---

### Publishing the gem to the Epimorphics GitHub Package Registry (eGPR)[^1]

This gem is made available to the various HMLR applications via the eGPR.

Note that in order to publish to the eGPR, you'll need a GitHub Personal Access
Token (PAT) with the appropriate permissions set.

> [!TIP]
> There are [instructions on the Epimorphics
> wiki](https://github.com/epimorphics/internal/wiki/Ansible-CICD#creating-a-pat-for-gpr-access)
> for creating a new PAT if you don't have one.
> Once created, you can use the same PAT in multiple projects, you don't need to
> create a new one each time.

#### Publishing an updated version of the gem is then a manual process

1. Make the required code changes, and have them reviewed by other members of
   the team
2. Update [`CHANGELOG.md`](/CHANGELOG.md) with the changes made
3. Update the proper version cadence found in the
   [`lib/qonsole_rails/version.rb`](/lib/qonsole_rails/version.rb)
   following [semantic versioning principles](https://semver.org/)
4. Check that the gem builds correctly locally by running the command: `make
   gem` in a terminal window
5. Visit the [project
   repository](https://github.com/epimorphics/qonsole-rails), navigate to the
   "[Actions](https://github.com/epimorphics/qonsole-rails/actions)" tab, and
   select the "Release and Publish Gem" workflow from the listing on the left
    - Click the "Run workflow" button on the right top of the workflow runs
      listing
    - Choose the **_"primary"_** branch to run the workflow on
    - Click the "Run workflow" button below the branch selection
6. When the workflow has completed, check on the eGPR[^1] to see that the new
   gem has been published successfully
