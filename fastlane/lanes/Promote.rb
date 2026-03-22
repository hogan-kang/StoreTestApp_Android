# fastlane/lanes/Promote.rb

platform :android do
  desc "Promote an existing release from one track to another with version validation"
  # Usage: fastlane android promote from:internal to:alpha version_code:12345
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
      # package_name is automatically read from Appfile
      json_key_data: ENV['SERVICE_ACCOUNT_JSON'],
      version_code: version,        # Specify exactly which version code to promote
      track: dest_track,           # Destination track
      from_track: source_track,    # Source track
      
      # NOTE: If the destination track is "Under Review", this call may fail.
      # It is recommended to enable "Managed Publishing" in Google Play Console.
      
      # Ensure the destination track's release ONLY contains this promoted version
      version_codes_to_retain: [], 

      # Automatically deactivate the version in the source track after a successful promotion
      deactivate_on_promote: true,

      skip_upload_aab: true,       # Do not upload a new binary
      skip_upload_apk: true,
      skip_upload_metadata: true,
      skip_upload_changelogs: true, 
      skip_upload_images: true,
      skip_upload_screenshots: true,
      # CHANGED: Use "draft" to allow manual review before rollout
      release_status: "draft"
    )
  end
end
