try
    rm("emojis_flattened", recursive=true)
    rm("emojis_scaled", recursive=true)
    rm("emojis_scaled_flattened", recursive=true)
    rm("emojis_scaled_svg_flattened", recursive=true)
    rm("emojis_svg", recursive=true)
    rm("emojis_svg_flattened", recursive=true)
catch
end

run(`julia scripts/resize.jl "emojis" 100% true`)
mv("emojis_scaled_flattened", "emojis_flattened")

run(`julia scripts/resize.jl "emojis" 200% false`)
run(`julia scripts/resize.jl "emojis" 200% true`)

run(`julia scripts/tosvg.jl "emojis" false`)
run(`julia scripts/tosvg.jl "emojis" true`)

run(`julia scripts/tosvg.jl "emojis_scaled" true`)
