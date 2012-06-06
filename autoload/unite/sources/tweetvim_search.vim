let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#tweetvim_search#define()
  return [s:source_search, s:source_search_new]
endfunction

let s:source_search = {
\   'name' : 'tweetvim/search',
\ }

function! s:source_search.gather_candidates(args, context)
  call s:cache_read()
  let candidates = []
  for word in s:cache['words']
    call add(candidates, {
          \   'word' : word,
          \   'kind' : 'command',
          \   'action__command' : "call unite#sources#tweetvim_search#search('" . word . "')",
          \ })
  endfor
  return candidates
endfunction


let s:source_search_new = {
\   'name' : 'tweetvim/search_new',
\ }

function! s:source_search_new.change_candidates(args, context)
  let word = a:context.input
  return [ {
        \   'word' : word,
        \   'kind' : 'command',
        \   'action__command' : "call unite#sources#tweetvim_search#search('" . word . "')",
        \ } ]
endfunction


function! unite#sources#tweetvim_search#search(word)
  call s:cache_write(a:word)
  call tweetvim#timeline('search', a:word)
endfunction


let s:fname = g:tweetvim_config_dir . '/search_history'
let s:cache = { 'words' : [], 'ftime' : -1 }

function! s:cache_read()
  if s:cache['ftime'] != getftime(s:fname)
    let s:cache['words'] = filereadable(s:fname) ? filter(readfile(s:fname), "v:val !=# '^\s*$'") : []
    let s:cache['ftime'] = getftime(s:fname)
  endif
endfunction

function! s:cache_write(word)
  call s:cache_read()
  if index(s:cache['words'], a:word) == -1
    call writefile(sort(add(s:cache['words'], a:word)), s:fname)
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

