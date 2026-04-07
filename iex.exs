IEx.configure(
  colors: [
    syntax_colors: [
      number: :light_yellow,
      atom: :light_cyan,
      string: :light_green,
      boolean: :magenta,
      nil: [:magenta, :bright]
    ],
    eval_result: [:cyan, :bright]
  ],
  inspect: [
    pretty: true,
    limit: :infinity,
    width: 80
  ],
  history_size: 100
)
