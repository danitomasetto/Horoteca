abstract final class AppConfig {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://nlkhbhgzscpdistzuyod.supabase.co',
  );

  // Public client key. Authorization is enforced by Supabase RLS.
  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5sa2hiaGd6c2NwZGlzdHp1eW9kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU5NTQ3MDgsImV4cCI6MjEwMTUzMDcwOH0.Niy8n76LZnvIbwbItuP8164Rx7wduU9q8tTwTGY21B8',
  );
}
