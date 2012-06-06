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


let s:source_tag_buffer = {
\   'name' : 'tweetvim/tag_buffer',
\ }

function! s:source_tag_buffer.gather_candidates(args, context)
  let pattern = '[ 　。、]\zs[#＃][^ ].\{-1,}\ze[ \n]'
  let tags = []
  for line in getbufline('%', 1, '$')
    let line = line . ' '
    while 1
      let tag = matchstr(line, pattern)
      if tag ==# ''
        break
      endif
      call add(tags, substitute(tag, '[#＃]', '', ''))
      let line = substitute(text, tag, '', '')
    endwhile
  endfor

  let candidates = []
  for word in tags
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
  return [s:source_tag, s:source_tag_buffer]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

