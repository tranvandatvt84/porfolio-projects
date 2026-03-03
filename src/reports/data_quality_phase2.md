# Phase 2 Data Quality Report

## Summary KPIs
- **rows**: 3000000
- **min_date**: 2019-01-01
- **max_date**: 2023-08-31
- **unique_carriers**: 18
- **unique_airports**: 380
- **cancel_rate**: 0.02638
- **divert_rate**: 0.002352
- **dep_delay_15_rate**: 0.17728266666666667
- **arr_delay_15_rate**: 0.17795433333333333
- **severe_arr_delay_60_rate**: 0.059470666666666665

## Delay minutes sanity stats

|   dep_delay_min_min |   dep_delay_min_median |   dep_delay_min_max |   arr_delay_min_min |   arr_delay_min_median |   arr_delay_min_max |
|--------------------:|-----------------------:|--------------------:|--------------------:|-----------------------:|--------------------:|
|                 -90 |                     -2 |                2966 |                 -96 |                     -7 |                2934 |

## Average delay minutes by cause (if available)

|   avg_delay_due_carrier |   avg_delay_due_weather |   avg_delay_due_nas |   avg_delay_due_security |   avg_delay_due_late_aircraft |
|------------------------:|------------------------:|--------------------:|-------------------------:|------------------------------:|
|                 24.7591 |                 3.98526 |             13.1647 |                 0.145931 |                       25.4713 |

## Null rates (top 25)

| col                     |   nulls |   null_rate |
|:------------------------|--------:|------------:|
| flight_num              | 3000000 | 1           |
| delay_due_carrier       | 2466137 | 0.822046    |
| delay_due_weather       | 2466137 | 0.822046    |
| delay_due_nas           | 2466137 | 0.822046    |
| delay_due_security      | 2466137 | 0.822046    |
| delay_due_late_aircraft | 2466137 | 0.822046    |
| arr_delay_min           |   86198 | 0.0287327   |
| air_time_min            |   86198 | 0.0287327   |
| arr_min                 |   81358 | 0.0271193   |
| taxi_in_min             |   79944 | 0.026648    |
| taxi_out_min            |   78806 | 0.0262687   |
| dep_min                 |   77857 | 0.0259523   |
| dep_delay_min           |   77644 | 0.0258813   |
| crs_arr_min             |      14 | 4.66667e-06 |
| flight_date             |       0 | 0           |
| year                    |       0 | 0           |
| month                   |       0 | 0           |
| dow                     |       0 | 0           |
| carrier                 |       0 | 0           |
| origin                  |       0 | 0           |
| dest                    |       0 | 0           |
| crs_dep_min             |       0 | 0           |
| is_cancelled            |       0 | 0           |
| is_diverted             |       0 | 0           |
| is_dep_delayed_15       |       0 | 0           |

## Top airports by total flights (origin + dest)

| airport   |   flights |
|:----------|----------:|
| ATL       |    307125 |
| DFW       |    260104 |
| ORD       |    245630 |
| DEN       |    239511 |
| CLT       |    189717 |
| LAX       |    171493 |
| PHX       |    150420 |
| LAS       |    146932 |
| SEA       |    141738 |
| MCO       |    127701 |
| IAH       |    124743 |
| LGA       |    124542 |
| DTW       |    124466 |
| MSP       |    119790 |
| SFO       |    118539 |
