# PR size labeler

A label on every pull request telling reviewers how big it is. The point is not decoration:
a 2000-line PR gets a different kind of review than a 30-line one, and the label makes that
visible before anyone opens the diff.

```yaml
name: Size
on:
  pull_request:
    types: [opened, synchronize, reopened]

permissions:
  contents: read
  pull-requests: write
  issues: write

jobs:
  label:
    runs-on: ubuntu-latest
    steps:
      - uses: hfip/pr-size-labeler@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
```

## What it does

1. Reads `additions` and `deletions` for the pull request.
2. Picks `size/xs`, `size/s`, `size/m`, `size/l` or `size/xl`.
3. Creates the label if the repository does not have it yet, with a matching colour.
4. Removes the previous size label so a PR never carries two.
5. Prints a one-line summary in the action log.

| label | changed lines | colour |
| --- | --- | --- |
| `size/xs` | under 10 | green |
| `size/s` | under 100 | blue |
| `size/m` | under 500 | yellow |
| `size/l` | under 1000 | orange |
| `size/xl` | 1000 and up | red |

Thresholds and the prefix are inputs:

```yaml
- uses: hfip/pr-size-labeler@v1
  with:
    token: ${{ secrets.GITHUB_TOKEN }}
    prefix: "diff/"
    m-max: "300"
    l-max: "800"
```

## Testing

The size rules live in `scripts/size.sh` as a pure function, so they can be tested without
GitHub at all:

```bash
bash tests/size_test.sh
```

The suite covers every boundary (`9`, `10`, `99`, `100`, …), environment overrides and the
colour map. CI runs it on every push.

## Limits

- It counts lines, not complexity. A 40-line change in a payment path is not "tiny".
- Generated files and lockfiles inflate the number; use the repository's `linguist` or
  paths-ignore settings if that matters.
- It labels only. Blocking a PR is a branch protection decision, not an action's job.
- It needs `issues: write` (labels live on the issue API) in addition to
  `pull-requests: write`.

## بالعربي

<div dir="rtl" align="right">

وسم بسيط على كل Pull Request يبين حجمه: ٢٠ سطر ولا ٢٠٠٠ سطر. المراجع يتعامل معهم
بشكل مختلف، والوسم يوضّح الفرق قبل ما يفتح الفرق.

```yaml
- uses: hfip/pr-size-labeler@v1
  with:
    token: ${{ secrets.GITHUB_TOKEN }}
```

يضيف الوسم وينشئه إذا مو موجود، ويشيل الوسم القديم عشان ما يجتمع اثنين. القواعد في
`scripts/size.sh` ومختبَرة بدون GitHub.

</div>

## License

MIT. See [LICENSE](LICENSE).
