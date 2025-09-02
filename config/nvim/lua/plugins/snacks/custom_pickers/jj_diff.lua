return {
  title = "JJ Diff (Working Copy)",
  -- same UI as git_diff
  format = "git_status",
  preview = "diff",
  matcher = {
    sort_empty = true,
  },
  sort = {
    fields = { "score:desc", "file", "idx" },
  },
  finder = function(opts, ctx)
    opts = opts or {}

    local Diff = require("snacks.picker.source.diff")

    -- Use the repo root as cwd (same as Snacks' git sources)
    local cwd = ctx:git_root() or ctx:cwd()
    ctx.picker:set_cwd(cwd)

    -- Build the jj diff command
    local args = {
      "diff",
      "--git",                   -- git-style unified diff
      "--color=never",           -- no ANSI colors in output
    }

    -- Optional: if you later call this picker with opts.rev / from / to
    if opts.rev then
      -- jj: -r / --revisions <revset>
      table.insert(args, "--revisions")
      table.insert(args, opts.rev)
    elseif opts.from or opts.to then
      if opts.from then
        table.insert(args, "--from")
        table.insert(args, opts.from)
      end
      if opts.to then
        table.insert(args, "--to")
        table.insert(args, opts.to)
      end
    end

    -- Let Snacks' diff source parse the jj diff
    return Diff.diff(ctx:opts({
      cmd = "jj",
      args = args,
      cwd = cwd,
    }), ctx)
  end,
  -- leave actions empty; default confirm/accept = jump to file+line
  win = {
    input = {
      keys = {
        -- Override confirm only for jj_diff (both insert & normal)
        ["<CR>"] = { "jj_diff_confirm", mode = { "i", "n" } },
      },
    },
  },

  actions = {
    jj_diff_confirm = function(picker, _, action)
      local Actions = require("snacks.picker.actions")

      -- Adjust all selected items before jumping
      local items = picker:selected({ fallback = true })

      for _, item in ipairs(items) do
        local block = item.block
        if block and block.hunks and item.pos then
          -- Find the hunk that this item corresponds to
          local hunk
          for _, h in ipairs(block.hunks) do
            if h.line == item.pos[1] then
              hunk = h
              break
            end
          end

          if hunk and hunk.diff then
            -- hunk.diff[1] is the @@ header; start counting from the first body line
            local lnum = hunk.line

            for i = 2, #hunk.diff do
              local line = hunk.diff[i]
              local c = line:sub(1, 1)

              if c == "+" then
                -- First added line: jump here
                item.pos[1] = lnum
                break
              elseif c == " " then
                -- Context lines advance the new-file line number
                lnum = lnum + 1
              elseif c == "-" then
                -- Deletion: affects old file only, do not increment lnum
              end
            end
          end
        end
      end

      -- Now run the normal jump (confirm) logic
      Actions.jump(picker, nil, action)
    end,
  },
}
