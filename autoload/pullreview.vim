if exists("g:loaded_pullreview")
  finish
endif
let g:loaded_pullreview = 1

sign define pullreviewcomment text=↪ texthl=Search
sign define pullreviewcommentgreen text=↪ texthl=DiffAdd

if has('ruby')
  ruby $: << File.expand_path(File.join(Vim.evaluate('g:PULLREVIEW_INSTALL_PATH'), '..', 'lib'))
  ruby require 'pull_review'

  function pullreview#go_to_file()
    let l:line_number = line(".")
    ruby PullReview::GoToFile.call(Vim.evaluate("l:line_number"))
  endfunction

  function pullreview#go_to_previous_commented_line()
    let l:line_number = line(".")
    ruby PullReview::GoToCommentLine.new(Vim.evaluate("l:line_number")).previous()
  endfunction

  function pullreview#go_to_next_commented_line()
    let l:line_number = line(".")
    ruby PullReview::GoToCommentLine.new(Vim.evaluate("l:line_number")).next()
  endfunction

  function pullreview#new_comment()
    let l:line_number = line(".")
    ruby PullReview::View::NewComment.new(Vim.evaluate("l:line_number")).call
  endfunction

  function pullreview#save_comment(args_dict)
    ruby PullReview::SaveComment.new(Vim.evaluate("a:args_dict")).call
  endfunction

  function pullreview#show_comment_chain()
    let l:line_number = line(".")
    ruby PullReview::View::CommentChain.new(Vim.evaluate("l:line_number")).call
  endfunction

  function pullreview#show_pull_request()
    let l:line = getline(".")
    ruby PullReview::CommentChain.load(Vim.evaluate("l:line"))
    ruby PullReview::Diff.load(Vim.evaluate("l:line"))
    ruby PullReview::DiffMap.load_from_loaded_diff()
    ruby PullReview::PullRequest.load(Vim.evaluate("l:line"))
    ruby PullReview::View::PullRequest.new(Vim.evaluate("l:line")).call()
  endfunction

  function pullreview#show_pull_request_list()
    ruby PullReview::View::PullRequestList.call()
  endfunction
endif
