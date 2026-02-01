# ==============================================================================
# Recursive to-SVG
# ==============================================================================
# Usage: julia tosvg.jl <input_directory> <flatten>
# Example: julia tosvg.jl "./photos" true
# ==============================================================================

using Printf

# Configuration: Supported image extensions
const IMAGE_EXTENSIONS = Set([".jpg", ".jpeg", ".png", ".bmp", ".tiff", ".tif", ".gif", ".webp"])

# Helper to check if a file is an image based on extension
function is_image(filename::String)
    _, ext = splitext(lowercase(filename))
    return ext in IMAGE_EXTENSIONS
end

function convert_images_recursive(input_dir::String, flatten::Bool)
    if !isdir(input_dir)
        println("Error: Input directory '$input_dir' does not exist.")
        exit(1)
    end

    clean_input = rstrip(abspath(input_dir), ['/', '\\'])
    output_dir = clean_input * "_svg"
    if flatten
        output_dir *= "_flattened"
    end

    println("$clean_input -> $output_dir")

    for (root, _, files) in walkdir(clean_input)
        rel_path = relpath(root, clean_input)
        if flatten
            target_dir = output_dir
        else
            target_dir = joinpath(output_dir, rel_path)
        end

        if !isdir(target_dir)
            mkpath(target_dir)
        end

        for file in files
            if is_image(file)
                src_file = joinpath(root, file)
                dest_file = joinpath(target_dir, file)
                path, extension = splitext(dest_file)
                dest_file_svg = path * ".svg"
                try
                    cmd = `psvg -i $src_file -o $dest_file_svg`
                    run(cmd)

                    println("[OK] Converted: $rel_path/$file")
                catch e
                    println("[ERROR] Failed to convert $file: $e")
                end
            else
                cp(joinpath(root, file), joinpath(target_dir, file), force=true)
                println("[SKIP] Non-image: $file")
            end
        end
    end

    println("\nDone! Check the folder: $output_dir")
end

if length(ARGS) == 1
    println("Usage: julia tosvg.jl <input_directory> <flatten>")
    exit(1)
else
    flatten = false
    if length(ARGS) == 2
        flatten = true
    end
    convert_images_recursive(ARGS[1], flatten)
end
