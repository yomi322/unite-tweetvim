let s:save_cpo = &cpo
set cpo&vim

let s:source_name = {
\   'name' : 'tweetvim/name',
\ }

function! s:source_name.gather_candidates(args, context)
  let candidates = []
  for word in tweetvim#cache#get('screen_name')
    let word = '@' . word
    call add(candidates, {
          \   'word' : word,
          \   'kind' : 'command',
          \   'action__command' : "call unite#sources#tweetvim_search#search('" . word . "')",
          \ })
  endfor
  return candidates
endfunction


function! unite#sources#tweetvim_name#define()
  return s:source_name
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

