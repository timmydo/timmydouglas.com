---
date: 2021-05-01
tags:
- software
- costs
- twelve factor app
title: "Hidden Costs of Software Development"
---

I had an earlier post about [The Twelve Factor
App](/2019/07/27/twelve-factor-app.html). To summarize, someone put
together a guide of best practices when building a web application or
SaaS application. This post is sort of a tangential one: thoughts on
all the extra code that needs to be written to make a modern
distributed application _scale_--not just performance wise, but also
maintenance wise.

Many greenfield projects begin with a "I'll throw this
proof-of-concept together" and "it'll only take a few days." I want to
zoom into this and see if I can come together with why a few days
actually means a few months. Of course, your mileage may vary due to
existing tooling you may be able to use, but for the sake of this
post, I want to assume you're just using public tooling.

Let's assume the app you're writing is fairly generic. For this
example, let's say you read data from somewhere, manipulate it, then
put it somewhere else so that it can be queried. This could probably
describe most computer programs. Maybe this program takes a day to
prototype. But how long does it take to make it production ready?

You start by checking your code into a source control system. But this
needs to be able to have other people collaborate. You decide to use a
forge that has some CI/CD capabilities like
[GitHub](https://github.com/) or
[sourcehut](https://sourcehut.org/). You check it in there and choose
a license. If you're working for a company, there is probably some
extra bureaucratic paperwork you need to fill out and/or approvals if
you're going to make it open source.

Next you need to make sure that pull requests to your source code
repository go through some sort of verification. You add build checks
to make sure the source code builds. Then you forgot you didn't write
unit tests for your prototype, so you write those and you have the
build step also run those tests. Then you realize that you want people
to follow a style convention when contributing code so you document
the style rules and add another build gate that verifies
formatting. You set up required reviewers based on the path of the
files that are modified.

After changes are checked in, you want to build a release so that it
can be used. So you write scripts to generate build artifacts. But you
also want to make sure those build artifacts are valid, so you go back
and add integration tests that check that the build generates a
program that works. You realize you'd like this to happen on pull
request builds also, so you have it run there as well. You also decide
that you don't want people checking in code without tests, so you
figure out how to calculate test coverage as well. Then you add
another pull request gate that checks test coverage. 

Finally, your check-ins build artifacts that are tested. Next you want
to make it easier to deploy those changes. Since we're starting with
nothing, you need infrastructure to deploy those builds on. You decide
to treat infrastructure as code so you write more code to setup the
infrastructure if it doesn't exist yet. It uses a domain specific
language that you aren't as familiar with, so you spend a little bit
figuring that out.

You just wrote some code that creates your infrastructure on a popular
cloud provider using code. But you need to store a secret so that your
continuous delivery pipeline can access your cloud provider to create
the resources. So you use some cloud service to store secrets. You
also realize your web app needs to use secrets itself to authenticate
when downloading and uploading data. To get those secrets, you need to
have a bootstrap secret you can use to read the other secrets. To get
that bootstrap secret, you have to use a managed identity provided by
your orchestrator or cloud provider. You write that code, but then
you also leave another way to authenticate for when you're running the
code on your development machine.

You're almost there--or are you? You've created the infrastructure
with code, have the secret story figured out, now you just need to get
your artifacts on the machines and have them executed. You need to
find an orchestrator to run your application, restart it when it
crashes, etc. You decide on Kubernetes, because you don't want to get
locked into any specific cloud provider and everyone else is using it,
yada yada. So your build artifacts are docker images (you already set
up your own container repository and gave your Kubernetes cluster
access to it), but then you need to create the Kubernetes
configuration to specify how many instances of your application to
run, when to determine if it should be restarted, etc.

You figure out how to write all the Kubernetes YAML for the console
application you spent a couple of hours writing, but then decide that
you want to have some custom variables in that configuration that
depend on the environment. So you use a YAML generation tool like
Kustomize, and refactor your configuration to work with the new YAML
generation tool. You check that configuration metadata into your
source repository like everything else, and you make sure that build
gates are updated so bad configuration files won't get checked in.

Shortly after, you become worried about configuration drift in your
Kubernetes cluster, so instead of applying the YAML directly to your
cluster, you check in the configuration to another git repository that
is used as a source of truth by a GitOps tool. You update your
infrastructure as code scripts to make sure this is installed and
configured when your cluster is provisioned. You've already
spent a month automating the infrastructure and setting up CI/CD!

You quickly realize you have no idea what's going on with your app
when it's not running on your dev box, so you instrument it with open
telemetry, or whatever it gets renamed to in five years, to have logs
and metrics. You set up Prometheus and Grafana in your cluster because
you're too cheap to use a 3rd party service, and write some alerts to
page you if the reliability drops. You add another alert if data is
not coming in. You set up a service to call you if there is an alert
because you're not always checking your email.

You've got availability and reliability monitoring, you've expanded to
multiple regions for redundancy, but you want to make sure you have
some way to roll out new features gradually. You add canary
deployments and flighting features that let you enable/disable a
version of your app or a single feature within it. There goes another
month.

Next you decide you need to improve security, so you make sure all the
container images you use are coming from your container repository,
migrate to distroless, read-only containers that don't run as admin.
You disable direct network access to various service or control plane
areas. You use dependabot to update your source code dependencies. You
use just-in-time access, locked down laptops, and hardware keys for
admin roles/production access, and that's probably just scratching the
surface. You realize security can be a never-ending rathole.

Your service scales up. At this point you realize you haven't even
measured performance before. You create benchmarks, add pull-request
gates to verify against performance regressions, add counters for
performance-related things, and collect performance profiles of what
your production machines are spending their time on. You realize
you should be auto-scaling your workload more aggressively and taking
better advantage of cloud elasticity pricing.

Six months go by and you rewrite one part in a programming language
without a garbage collector because the GC is causing bursts in
latency. Repeat half the steps above to support this new programming
language. Imagine there are a lot more things that I forgot to write about.


All of a sudden, or not so suddenly, you realize you could spend a
year on the not-so-visible parts of a simple application running in
the cloud (or more, if you decide to implement the cloud parts
yourself?).
