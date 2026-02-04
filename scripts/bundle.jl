using Base.Filesystem

function copy_folders_with_prefix(source_root::String, dest_root::String, prefix::String)
    if isdir(dest_root)
        rm(dest_root, recursive=true)
    end

    println("Creating destination directory: $dest_root")
    mkpath(dest_root)

    println("Scanning '$source_root' for folders starting with '$prefix'...")
    items = readdir(source_root)
    count = 0

    for item in items
        src_path = joinpath(source_root, item)

        if isdir(src_path) && startswith(item, prefix)

            dest_path = joinpath(dest_root, item)

            println("  -> Found match: $item")
            println("     Copying to: $dest_path")

            try
                cp(src_path, dest_path; force=true)
                count += 1
            catch e
                println("     [!] Error copying $item: $e")
            end
        end
    end

    println("\nOperation complete. Copied $count folder(s).")
end

const SOURCE_DIR = "./"
const DEST_DIR = "./bundle"
const PREFIX = "emojis"

copy_folders_with_prefix(SOURCE_DIR, DEST_DIR, PREFIX)
