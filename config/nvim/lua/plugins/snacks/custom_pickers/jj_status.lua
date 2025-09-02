return {
  title = "JJ Status",
  -- same UI as git_diff
  format = "git_status",
  preview = "git_status",
  matcher = {
    sort_empty = true,
  },
  sort = {
    fields = { "score:desc", "file", "idx" },
  },
  finder = function(opts, ctx)
    opts = opts or {}

    local cwd = ctx:git_root() or ctx:cwd()
    ctx.picker:set_cwd(cwd)

    local args = {
      "status",
      "--no-pager",
      "--color=never", -- no ANSI colors in output
    }

    return require("snacks.picker.source.proc").proc(
      ctx:opts({
        cmd = "jj",
        args = args,
        cwd = cwd,
        ---@param item snacks.picker.finder.Item
        transform = function(item)
          local status, file = item.text:match("^([MADRC%?])%s+(.+)$")
          local git_xy
          if status == "M" then
            git_xy = " M"
          elseif status == "A" then
            git_xy = " A"
          elseif status == "D" then
            git_xy = " D"
          elseif status == "C" then
            git_xy = "C "
          elseif status == "R" then
            git_xy = " R"
          elseif status == "?" then
            git_xy = "??"
          end
          if git_xy then
            item.cwd = cwd
            item.file = file
            item.status = git_xy
            if item.status == " R" then
              local _, rel_path, rename, new_file = item.text:match("^([MADRC%?])%s+(.*){(.+)%s+=>%s+(.+)}")
              if rel_path ~= nil and rename ~= nil and new_file ~= nil then
                item.file = rel_path .. new_file
                item.rename = rel_path .. rename
              else
                vim.notify("jj status picker couldn't regex match rename pattern: " .. item.text, "debug")
                return false
              end
            end
          else
            return false
          end
        end,
      }), ctx)
  end,
}
