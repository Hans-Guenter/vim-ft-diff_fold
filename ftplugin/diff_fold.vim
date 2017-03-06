" Folding setting for diff.
" Version: 0.2.0
" Author : thinca <thinca+vim@gmail.com>
" License: zlib License

setlocal foldmethod=expr foldexpr=DiffFold(v:lnum)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setl fdm< fde<'


if exists('*DiffFold')
  finish
endif

let s:file_pat = '^\%(Index:\|diff\|Only in\|Binary files\) '
let s:file_pat_diff = '^\%(Index:\|diff\) '
let s:file_pat_only = '^\%(Only in\|Binary files\) '
function! DiffFold(lnum)
  let line = getline(a:lnum)
  let next = getline(a:lnum + 1)
  let prev = getline(a:lnum - 1)
  let prev2 = getline(a:lnum - 2)
  if line =~ '^[-=]\{3} ' && (prev2 !~# s:file_pat_diff || prev2 =~# s:file_pat_only)
    return 1
  elseif line =~# s:file_pat && prev !~# s:file_pat_only
    return '<1'
  elseif next =~ '^[-=]\{3} ' && (prev !~# s:file_pat_diff || prev =~# s:file_pat_only)
  elseif line =~# s:file_pat && next !~# s:file_pat_only
    return 1
  elseif next =~# s:file_pat
    return '<1'
  elseif line =~ '^@@ '
    return 2
  elseif next =~ '^@@ '
    return '<2'
  endif
  return '='
endfunction
