# astryx_ui

An unofficial Flutter port of [Astryx](https://github.com/facebook/astryx), Meta's
design system for building internal tools and products.

> **Status: pre-alpha.** Nothing is published yet and the API is unstable. See
> [`dev/04-TRACKER.md`](../dev/04-TRACKER.md) for what is built and what is not.

## What this is

Astryx is a React + StyleX design system. `astryx_ui` reimplements it for
Flutter:

- **A faithful theme engine.** Astryx's token defaults, scale expanders, HCT
  color model, and contrast math ported to Dart, verified against the upstream
  test suite. Custom themes generate the same values the React version does.
- **All seven prebuilt themes** — neutral, matcha, stone, gothic, chocolate,
  y2k, butter.
- **Components built on `flutter/widgets`**, not Material. Every widget is
  themeable through the same token layer.
- **Every platform.** Pointer and touch are both first-class: dual density,
  platform-appropriate touch targets, and a gesture path for every hover
  interaction.

## What this is not

- Not affiliated with, endorsed by, or supported by Meta Platforms, Inc.
- Not a 1:1 port of all ~100 Astryx components. See
  [`dev/reference/COMPONENT-INVENTORY.md`](../dev/reference/COMPONENT-INVENTORY.md)
  for the scope of 1.0 and what is deferred.

## Installation

Not yet published to pub.dev.

## Usage

Documented per component as each ships. See
[`dev/00-MASTER-PLAN.md`](../dev/00-MASTER-PLAN.md) for the delivery schedule.

## Contributing

The full development process — architecture, conventions, porting rules, phase
plans, and the session tracker — lives in the [`dev/`](../dev/) directory at the
repository root. Start with [`dev/README.md`](../dev/README.md).

## License

MIT. Derived from Astryx (MIT, Copyright &copy; 2026 Meta Platforms, Inc.).
See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE).
