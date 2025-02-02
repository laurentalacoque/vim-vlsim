" Test suite for VlsiYank for VHDL
" Install https://github.com/laurentalacoque/vim-unittest (fixed version of 
" https://github.com/h1mesuke/vim-unittest)
" Run :UnitTest <this file>
" NOTE: some tests are currently failing and are skipped, define global variable 
"       g:include_failing_tests to include them
"
" where are we?
let s:here= expand('<sfile>:p:h')

"--------------------------------------------------------------------------------
" Helper functions for module comparison 
"--------------------------------------------------------------------------------
" {{{ 1
"
" module comparator
" compare module content in actual with awaited value in wanted
function! s:assert_module_equals(wanted,actual) dict
    " check for structure
"    " should be a dict
     call self.assert(type(a:actual) == type({}), "module should be a dictionnary")

    " should have basic keys
    for key in ["lang", "generics", "ports"]
        call self.assert(has_key(a:actual,key), "missing basic key " .. key)
    endfor

    "should have the same keys
    for key in keys(a:wanted)
        call self.assert(has_key(a:actual,key), "missing key " .. key)
    endfor
    for key in keys(a:actual)
        if key !=# 'file'
            call self.assert(has_key(a:wanted,key), "extraneous key " .. key)
        endif
    endfor

    " compare lang
    call self.assert_equal(a:wanted.lang, a:actual.lang, "'lang' mismatch")

    " compare generics sizes
    call self.assert_equal(len(a:wanted.generics), len(a:actual.generics), "generics size mismatch")
    if len(a:wanted.generics) == len(a:actual.generics)
        " size matches
        for i in range(len(a:actual.generics))
            call self.assert_equal(a:wanted.generics[i], a:actual.generics[i],"mismatch for generics[" .. i.."]")
        endfor
    endif

    " compare ports sizes
    call self.assert_equal(len(a:wanted.ports), len(a:actual.ports), "ports size mismatch")
    if len(a:wanted.ports) == len(a:actual.ports)
        " size matches
        for i in range(len(a:actual.ports))
            call self.assert_equal(a:wanted.ports[i], a:actual.ports[i],"mismatch for ports[" .. i .."]")
        endfor
    endif



endfunction

" Goto data(label)
" VlsiYank
" Compare yanked module to provided module_data
function! s:goto_yank_compare_module(label, module_data) dict
    call self.data.goto(a:label)
    silent VlsiYank
    call self.assert(has_key(g:modules,a:label), "capture failed for "..a:label)
    call self.assert_module_equals(a:module_data, g:modules[a:label])
endfunction

" }}}

"--------------------------------------------------------------------------------
" Testcase
"--------------------------------------------------------------------------------
let s:tc = unittest#testcase#new("Test VlsiYank functions for VHDL", {'data' : s:here .. '/ressources/test_file.vhd'})

"--------------------------------------------------------------------------------
" Setup and Teardown
"--------------------------------------------------------------------------------
" {{{ 1

""" Once SETUP
function! s:tc.SETUP()
    " define markers for data accessors
    call self.puts("Setting marker format for VHDL")
    let self.data.marker_formats = ['-- begin %s', '-- end %s']
    " Add our comparison functions
    let s:tc.assert_module_equals = function ('s:assert_module_equals')
    let s:tc.assert_yank_module_equals = function ('s:goto_yank_compare_module')
endfunction

""" every test setup
function! s:tc.setup()
    " Always start with an empty g:modules and g:interfaces
    let g:modules = {}
    let g:interfaces = {}
endfunction

" }}}

""" test functions


"--------------------------------------------------------------------------------
" Generics Tests
"--------------------------------------------------------------------------------
" {{{ 1
function! s:tc.test_vhd_yank_minimal()
    let  l:label = 'minimal'
    let  s:wanted = #{ lang:'vhdl', generics:[], ports:[]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

function! s:tc.test_vhd_yank_generic1()
    let  l:label = 'generic1'
    let  s:wanted = #{ lang:'vhdl', generics:[#{name:'param1', type:'natural', value:'4'}], ports:[]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

function! s:tc.test_vhd_yank_generic1a()
    let  l:label = 'generic1a'
    let  s:wanted = #{ lang:'vhdl', generics:[#{name:'param1', type:'natural', value:'4'}], ports:[]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

function! s:tc.test_vhd_yank_generic1b()
    let  l:label = 'generic1b'
    let  s:wanted = #{ lang:'vhdl', generics:[#{name:'param1', type:'natural', value:'4'}], ports:[]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

function! s:tc.test_vhd_yank_generics_multi()
    let  l:label = 'generics_multi'
    let  s:wanted = #{ lang:'vhdl', generics:[
        \ #{name:'truc', type:'natural', value:'4'},
        \ #{name:'machin', type:'natural', value:'33'},
        \ #{name:'chose', type:'natural', value:'10'},
        \ #{name:'thing', type:'natural', value:'8'},
        \ ], ports:[]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction
" }}}
"--------------------------------------------------------------------------------
" Ports Tests
"--------------------------------------------------------------------------------
" {{{ 1

function! s:tc.test_vhd_yank_port1()
    let  l:label = 'port1'
    let  s:wanted = #{ lang:'vhdl', generics:[], ports:[
        \ #{name:'port1', type:'std_logic', range:0, dir:'i'}
        \ ]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

function! s:tc.test_vhd_yank_port1a()
    let  l:label = 'port1a'
    let  s:wanted = #{ lang:'vhdl', generics:[], ports:[
        \ #{name:'port1', type:'std_logic', range:0, dir:'i'}
        \ ]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

function! s:tc.test_vhd_yank_port1b()
    let  l:label = 'port1b'
    let  s:wanted = #{ lang:'vhdl', generics:[], ports:[
        \ #{name:'port1', type:'std_logic', range:0, dir:'i'}
        \ ]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

function! s:tc.test_vhd_yank_ports_multi()
    let  l:label = 'ports_multi'
    let  s:wanted = #{ lang:'vhdl', generics:[], ports:[
                \ #{name:'port1', type:'std_logic', range:0, dir:'i'},
                \ #{name:'port2', type:'std_logic', range:0, dir:'o'},
                \ #{name:'port3', type:'std_logic', range:0, dir:'io'},
                \ ]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

" }}}
"--------------------------------------------------------------------------------
" Ports and generics tests
"--------------------------------------------------------------------------------
" {{{ 1

function! s:tc.test_failing_vhd_yank_ports_and_generics1()
    if !exists('g:include_failing_tests')
        return
    endif
    let  l:label = 'pg1'
    let  s:wanted = #{ lang:'vhdl', generics:[
        \ #{name:'param1', type:'natural', value:'4'}
        \ ], ports:[
        \ #{name:'port1', type:'std_logic', range:0, dir:'o'}
        \ ]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

function! s:tc.test_failing_vhd_yank_ports_and_generics1a()
    if !exists('g:include_failing_tests')
        return
    endif
    let  l:label = 'pg1a'
    let  s:wanted = #{ lang:'vhdl', generics:[#{name:'param1', type:'natural', value:'4'}], ports:[
        \ #{name:'port1', type:'std_logic', range:0, dir:'i'}
        \ ]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

function! s:tc.test_vhd_yank_ports_and_generics1b()
    let  l:label = 'pg1b'
    let  s:wanted = #{ lang:'vhdl', generics:[#{name:'param1', type:'natural', value:'4'}], ports:[
        \ #{name:'port1', type:'std_logic', range:0, dir:'i'}
        \ ]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

function! s:tc.test_vhd_yank_ports_and_genericss_multi()
    let  l:label = 'pgs_multi'
    let  s:wanted = #{ lang:'vhdl', generics:[
                \ #{name:'truc', type:'natural', value:'4'},
                \ #{name:'machin', type:'natural', value:'33'},
                \ #{name:'chose', type:'natural', value:'10'},
                \ #{name:'thing', type:'natural', value:'8'},
                \], ports:[
                \ #{name:'port1', type:'std_logic', range:0, dir:'i'},
                \ #{name:'port2', type:'std_logic', range:0, dir:'o'},
                \ #{name:'port3', type:'std_logic', range:0, dir:'io'},
                \ ]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

" }}}
"--------------------------------------------------------------------------------
" Ports with range
"--------------------------------------------------------------------------------
" {{{ 1

function! s:tc.test_vhd_yank_port_with_range()
    let  l:label = 'pr1'
    let  s:wanted = #{ lang:'vhdl', generics:[
            \ #{name:'BUS_WIDTH', type:'natural', value:'32'}
        \ ], ports:[
            \ #{name:'bus1', type:'std_logic_vector',  range:'BUS_WIDTH-1{{:}}0', dir:'i'},
            \ #{name:'bus2', type:'std_logic_vector', range:'31{{:}}0', dir:'i'}
        \ ]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

" }}}
"--------------------------------------------------------------------------------
" Ports with default port type
"--------------------------------------------------------------------------------
" {{{ 
"
function! s:tc.test_failing_vhd_yank_port_list()
    if !exists('g:include_failing_tests')
        return
    endif
    let  l:label = 'pdt1'
    let  s:wanted = #{ lang:'vhdl', generics:[
        \ ], ports:[
            \ #{name:'port1', type:'std_logic',  range:0, dir:'i'},
            \ #{name:'port2', type:'std_logic',  range:0, dir:'i'},
            \ #{name:'port3', type:'std_logic',  range:0, dir:'o'},
            \ #{name:'port4', type:'std_logic',  range:0, dir:'io'},
        \ ]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

function! s:tc.test_failing_vhd_yank_ports_on_single_line()
    if !exists('g:include_failing_tests')
        return
    endif
    let  l:label = 'pdt2'
    let  s:wanted = #{ lang:'vhdl', generics:[
        \ ], ports:[
            \ #{name:'port1', type:'std_logic',  range:0, dir:'i'},
            \ #{name:'port2', type:'std_logic',  range:0, dir:'i'},
            \ #{name:'port3', type:'std_logic',  range:0, dir:'o'},
            \ #{name:'port4', type:'std_logic',  range:0, dir:'io'},
        \ ]}
    call self.assert_yank_module_equals(l:label, s:wanted)
endfunction

" }}}
"--------------------------------------------------------------------------------
" YankAll
"--------------------------------------------------------------------------------
" {{{ 
"
function! s:tc.test_v_yankall()
    let  l:command = "VlsiYankAll "..s:here.."/ressources/test_file.vhd"
    silent execute l:command
    
    if self.assert_exists('g:modules', "VlsiYankAll: no module captured")
        for modname in [
                    \'minimal',
                    \'generic1',
                    \'generic1a',
                    \'generic1b',
                    \'generics_multi',
                    \'port1',
                    \'port1a',
                    \'port1b',
                    \'ports_multi',
                    \'pg1',
                    \'pg1a',
                    \'pg1b',
                    \'pgs_multi',
                    \'pr1',
                    \'pdt1',
                    \'pdt2',
                    \]
            call self.assert_has_key(modname, g:modules, "VlsiYankAll : missing module ".. modname)
        endfor
    endif

endfunction

" }}}


" vim: :fdm=marker
