let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#tweetvim_name#define()
  return s:source_name
endfunction

let s:source_name = {
      \   'name' : 'tweetvim/name',
      \   'action_table' : {},
      \   'default_action' : 'tweet',
      \ }

function! s:source_name.gather_candidates(args, context)
  return map(tweetvim#cache#get('screen_name'), "{ 'word' : '@' . v:val }")
endfunction

let s:action_table = {}
let s:action_table.search = {
      \   'description' : 'search word in timeline',
      \   'is_selectable' : 1,
      \ }

function! s:action_table.search.func(candidates)
  let word = join(map(deepcopy(a:candidates), "v:val.word"))
  call unite#sources#tweetvim_search#search(word)
endfunction

let s:action_table.tweet = {
      \   'description' : 'tweet',
      \   'is_selectable' : 1,
      \ }

function! s:action_table.tweet.func(candidates)
  let name = join(map(deepcopy(a:candidates), "v:val.word"))
  call tweetvim#say#open(name . ' ')
endfunction

let s:action_table.user_timeline = {
      \   'description' : 'show user timeline',
      \ }

function! s:action_table.user_timeline.func(candidate)
  call tweetvim#timeline('user_timeline', a:candidate.word)
endfunction

let s:source_name.action_table = s:action_table

let &cpo = s:save_cpo
unlet s:save_cpo

