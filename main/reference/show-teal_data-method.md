# Show `teal_data` object

Prints `teal_data` object.

## Usage

``` r
# S4 method for class 'teal_data'
show(object)
```

## Arguments

- object:

  (`teal_data`)

## Value

Input `teal_data` object.

## Examples

``` r
teal_data()
#> ✅︎ code verified
#> <environment: 0x55a1e3122b78> 🔒 
#> Parent: <environment: devtools_shims> 
teal_data(x = iris, code = "x = iris")
#> ✖ code unverified
#> <environment: 0x55a1e3d72030> 🔒 
#> Parent: <environment: devtools_shims> 
#> Bindings:
#> - x: [data.frame]
verify(teal_data(x = iris, code = "x = iris"))
#> ✅︎ code verified
#> <environment: 0x55a1e3cc43a0> 🔒 
#> Parent: <environment: devtools_shims> 
#> Bindings:
#> - x: [data.frame]
```
