let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#tweetvim_search#define()
  return [s:source_search, s:source_search_new]
endfunction

let s:source_search = {
      \   'name' : 'tweetvim/search',
      \   'action_table' : {},
      \   'default_action' : 'search',
      \ }

function! s:source_search.gather_candidates(args, context)
  call s:cache_read()
  return map(copy(s:cache['words']), "{ 'word' : v:val }")
endfunction

let s:source_search_new = {
      \   'name' : 'tweetvim/search_new',
      \   'action_table' : {},
      \   'default_action' : 'search',
      \ }

function! s:source_search_new.change_candidates(args, context)
  return [ { 'word' : a:context.input } ]
endfunction

let s:action_table = {}
let s:action_table.search = {
      \   'description' : 'search word in timeline',
      \   'is_selectable' : 1,
      \ }

function! s:action_table.search.func(candidates)
  let word = join(map(deepcopy(a:candidates), "v:val.word"))
  execute "call unite#sources#tweetvim_search#search('" . word . "')"
endfunction

let s:source_search.action_table = s:action_table
let s:source_search_new.action_table = s:action_table

function! unite#sources#tweetvim_search#search(word)
  call s:cache_write(a:word)
  call tweetvim#timeline('search', a:word)
endfunction

let s:fname = g:tweetvim_config_dir . '/search_history'
let s:cache = { 'words' : [], 'ftime' : -1 }

function! s:cache_read()
  if s:cache['ftime'] != getftime(s:fname)
    let s:cache['words'] = filereadable(s:fname) ? filter(readfile(s:fname), "v:val !=# ''") : []
    let s:cache['ftime'] = getftime(s:fname)
  endif
endfunction

function! s:cache_write(word)
  call s:cache_read()
  let new = filter(split(a:word), "index(s:cache['words'], v:val) == -1")
  if !empty(new)
    call writefile(sort(s:cache['words'] + new), s:fname)
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

