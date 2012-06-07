let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#tweetvim_tag#define()
  return [s:source_tag, s:source_tag_new, s:source_tag_buffer]
endfunction

let s:source_tag = {
      \   'name' : 'tweetvim/tag',
      \   'action_table' : {},
      \   'default_action' : 'tweet',
      \ }

function! s:source_tag.gather_candidates(args, context)
  return map(tweetvim#cache#get('hash_tag'), "{ 'word' : '#' . v:val }")
endfunction

let s:source_tag_new = {
      \   'name' : 'tweetvim/tag_new',
      \   'action_table' : {},
      \   'default_action' : 'tweet',
      \ }

function! s:source_tag_new.change_candidates(args, context)
  return [ { 'word' : '#' . a:context.input } ]
endfunction


let s:source_tag_buffer = {
      \   'name' : 'tweetvim/tag_buffer',
      \   'action_table' : {},
      \   'default_action' : 'tweet',
      \ }

function! s:source_tag_buffer.gather_candidates(args, context)
  let pattern = '[ 　。、]\zs[#＃][^ 　].\{-1,}\ze[ 　\n]'
  let tags = []
  for line in getbufline('%', 1, '$')
    let line = line . ' '
    while 1
      let tag = matchstr(line, pattern)
      if tag ==# ''
        break
      endif
      let line = substitute(line, tag, '', '')
      let tag = substitute(tag, '[#＃]', '', '')
      if index(tags, tag) == -1
        call add(tags, tag)
      endif
    endwhile
  endfor

  let candidates = []
  for word in tags
    let word = '#' . word
    call add(candidates, {
          \   'word' : word,
          \ })
  endfor
  return candidates
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

let s:action_table.tweet = {
      \   'description' : 'tweet',
      \   'is_selectable' : 1,
      \ }

function! s:action_table.tweet.func(candidates)
  let tag = join(map(deepcopy(a:candidates), "v:val.word"))
  execute "call tweetvim#say#open('" . tag . "')"
endfunction

let s:source_tag.action_table = s:action_table
let s:source_tag_new.action_table = s:action_table
let s:source_tag_buffer.action_table = s:action_table

let &cpo = s:save_cpo
unlet s:save_cpo

