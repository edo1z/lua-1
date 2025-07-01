local M = {}

-- サンプルデータ
M.tabs = {
  {
    name = "Languages",
    items = {
      {
        title = "Lua",
        description = "A powerful, efficient, lightweight, embeddable scripting language.\n\nLua is designed to be a lightweight embeddable scripting language.\nIt is used in many applications, including Neovim!",
        metadata = {
          type = "Scripting",
          year = "1993",
          creator = "Roberto Ierusalimschy",
        }
      },
      {
        title = "Python",
        description = "A high-level, interpreted programming language with dynamic semantics.\n\nPython's simple, easy to learn syntax emphasizes readability and\nreduces the cost of program maintenance.",
        metadata = {
          type = "General Purpose",
          year = "1991",
          creator = "Guido van Rossum",
        }
      },
      {
        title = "Rust",
        description = "A language empowering everyone to build reliable and efficient software.\n\nRust is blazingly fast and memory-efficient with no runtime or\ngarbage collector.",
        metadata = {
          type = "Systems Programming",
          year = "2010",
          creator = "Graydon Hoare",
        }
      },
      {
        title = "JavaScript",
        description = "A lightweight, interpreted programming language with first-class functions.\n\nJavaScript is the programming language of the Web and is used\nin millions of web pages and servers.",
        metadata = {
          type = "Web Development",
          year = "1995",
          creator = "Brendan Eich",
        }
      },
    }
  },
  {
    name = "Frameworks",
    items = {
      {
        title = "React",
        description = "A JavaScript library for building user interfaces.\n\nReact makes it painless to create interactive UIs. Design simple views\nfor each state in your application.",
        metadata = {
          type = "Frontend Framework",
          language = "JavaScript",
          company = "Meta",
        }
      },
      {
        title = "Django",
        description = "A high-level Python web framework that encourages rapid development.\n\nDjango follows the DRY principle and focuses on automating as much\nas possible.",
        metadata = {
          type = "Web Framework",
          language = "Python",
          motto = "The web framework for perfectionists with deadlines",
        }
      },
      {
        title = "SvelteKit",
        description = "The fastest way to build Svelte apps.\n\nSvelteKit is a framework for building web applications of all sizes,\nwith a beautiful development experience.",
        metadata = {
          type = "Full-Stack Framework",
          language = "JavaScript",
          compiler = "Yes",
        }
      },
    }
  }
}

-- 現在の状態
M.state = {
  active_tab = 1,
  selected_index = 1,
}

-- アクティブなタブを取得
function M.get_active_tab()
  return M.tabs[M.state.active_tab]
end

-- 選択中のアイテムを取得
function M.get_selected_item()
  local tab = M.get_active_tab()
  if tab and tab.items[M.state.selected_index] then
    return tab.items[M.state.selected_index]
  end
  return nil
end

-- 次のタブに移動
function M.next_tab()
  M.state.active_tab = M.state.active_tab % #M.tabs + 1
  M.state.selected_index = 1
end

-- 前のタブに移動
function M.prev_tab()
  M.state.active_tab = M.state.active_tab == 1 and #M.tabs or M.state.active_tab - 1
  M.state.selected_index = 1
end

-- 選択を上に移動
function M.move_up()
  local tab = M.get_active_tab()
  if tab and M.state.selected_index > 1 then
    M.state.selected_index = M.state.selected_index - 1
  end
end

-- 選択を下に移動
function M.move_down()
  local tab = M.get_active_tab()
  if tab and M.state.selected_index < #tab.items then
    M.state.selected_index = M.state.selected_index + 1
  end
end

return M