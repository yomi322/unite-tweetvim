let s:save_cpo = &cpo
set cpo&vim

let s:source_tag = {
\   'name' : 'tweetvim/tag',
\ }

function! s:source_tag.gather_candidates(args, context)
  let candidates = []
  for word in tweetvim#cache#get('hash_tag')
    let word = '#' . word
    call add(candidates, {
          \   'word' : word,
          \   'kind' : 'command',
          \   'action__command' : "call unite#sources#tweetvim_search#search('" . word . "')",
          \ })
  endfor
  return candidates
endfunction


function! unite#sources#tweetvim_tag#define()
  return s:source_tag
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

