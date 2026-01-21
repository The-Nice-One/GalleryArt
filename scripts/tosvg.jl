# Directory paths
input_dir = ARGS[1]
output_dir = ARGS[2]

# Create output directory if it doesn't exist
if !isdir(output_dir)
    mkdir(output_dir)
end

# Image extensions to process
image_extensions = [".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".webp"]

# Get all image files in the input directory
files = readdir(input_dir)
image_files = filter(f -> any(endswith(lowercase(f), ext) for ext in image_extensions), files)

println("Found $(length(image_files)) images to process")

# Process each image
for filename in image_files
    input_path = joinpath(input_dir, filename)

    output_path = joinpath(output_dir, filename)
    path, extension = splitext(output_path)
    output_path_svg = path * ".svg"

    # Use ImageMagick convert command with nearest neighbor sampling
    try
        run(`psvg -i $input_path -o $output_path_svg`)
        println("Processed: $filename")
    catch e
        println("Error processing $filename: $e")
    end
end

println("Done! SVG images saved to '$output_dir' directory")
