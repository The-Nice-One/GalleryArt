# ==============================================================================
# Recursive Image Scaler
# ==============================================================================
# Usage: julia image_scaler.jl <input_directory> <scale_size>
# Example: julia resize.jl "./photos" "50%"
# Example: julia resize.jl "./assets" "800x600"
# ==============================================================================

using Printf

# Configuration: Supported image extensions
const IMAGE_EXTENSIONS = Set([".jpg", ".jpeg", ".png", ".bmp", ".tiff", ".tif", ".gif", ".webp"])

# Helper to check if a file is an image based on extension
function is_image(filename::String)
    _, ext = splitext(lowercase(filename))
    return ext in IMAGE_EXTENSIONS
end

function scale_images_recursive(input_dir::String, scale_size::String)
    if !isdir(input_dir)
        println("Error: Input directory '$input_dir' does not exist.")
        exit(1)
    end

    clean_input = rstrip(abspath(input_dir), ['/', '\\'])
    output_dir = clean_input * "_scaled"

    println("$clean_input -> $output_dir ($scale_size)")

    for (root, _, files) in walkdir(clean_input)
        rel_path = relpath(root, clean_input)
        target_dir = joinpath(output_dir, rel_path)

        if !isdir(target_dir)
            mkpath(target_dir)
        end

        for file in files
            if is_image(file)
                src_file = joinpath(root, file)
                dest_file = joinpath(target_dir, file)
                try
                    cmd = `magick "$src_file" -resize $scale_size -filter point "$dest_file"`
                    run(cmd)

                    println("[OK] Scaled: $rel_path/$file")
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

if length(ARGS) < 2
    println("Usage: julia resize.jl <input_directory> <scale_size>")
    exit(1)
else
    scale_images_recursive(ARGS[1], ARGS[2])
end
