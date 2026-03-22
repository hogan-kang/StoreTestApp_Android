# fastlane/lanes/Promote.rb

platform :android do
  desc "Promote an existing release from one track to another with version validation"
  lane :promote do |options|
    source_track = options[:from]
    dest_track = options[:to]
    version = options[:version_code]
    
    # Validation: Ensure all three parameters are provided for safety
    UI.user_error!("Missing 'from' parameter. Usage: fastlane android promote from:internal to:alpha version_code:123") unless source_track
    UI.user_error!("Missing 'to' parameter. Usage: fastlane android promote from:internal to:alpha version_code:123") unless dest_track
    UI.user_error!("Missing 'version_code' parameter. Usage: fastlane android promote from:internal to:alpha version_code:123") unless version

    puts "🚀 Promoting version #{version} from #{source_track} to #{dest_track}..."

    upload_to_play_store(
      # package_name is now automatically read from Appfile
      json_key_data: ENV['SERVICE_ACCOUNT_JSON'],
      version_code: version,
      track: dest_track,
      from_track: source_track,
      skip_upload_aab: true,
      skip_upload_apk: true,
      skip_upload_metadata: true,
      skip_upload_changelogs: true, 
      skip_upload_images: true,
      skip_upload_screenshots: true,
      release_status: "completed"
    )
  end
end
