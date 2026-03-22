# fastlane/lanes/Deploy.rb

platform :android do
  desc "Upload a new binary to Google Play Internal track"
  lane :deploy do |options|
    # Get release note from options (passed from CLI)
    release_note = options[:note]
    
    # Validation: Ensure the 'note' parameter is provided
    UI.user_error!("Missing 'note' parameter. Usage: fastlane android deploy note:'Your release notes'") if release_note.to_s.empty?
    
    # 1. Create Release Notes directly in the standard fastlane/metadata folder
    metadata_base = File.join(Dir.pwd, "fastlane", "metadata")
    locales = ["en-US", "zh-CN", "zh-HK", "zh-TW"]

    locales.each do |locale|
      # Fastlane expects locale folders directly under the metadata path.
      changelog_dir = File.join(metadata_base, locale, "changelogs")
      FileUtils.mkdir_p(changelog_dir)
      File.write(File.join(changelog_dir, "default.txt"), release_note)
    end

    # 2. Upload to Google Play
    upload_to_play_store(
      # package_name is automatically read from Appfile
      json_key_data: ENV['SERVICE_ACCOUNT_JSON'],
      track: "internal",
      release_status: "completed",
      aab: "app/build/outputs/bundle/release/app-release-signed.aab",
      metadata_path: metadata_base,
      version_codes_to_retain: [],
      
      # IMPORTANT: Keep changes in "Publishing overview" and DO NOT trigger auto-review.
      # This prevents internal builds from pushing other track drafts into review.
      changes_not_sent_for_review: true,

      skip_upload_metadata: true,
      skip_upload_changelogs: false,
      skip_upload_apk: true,
      skip_upload_images: true,
      skip_upload_screenshots: true
    )
  end
end
