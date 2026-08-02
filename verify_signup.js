const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_ANON_KEY);

async function run() {
  const email = `test_${Date.now()}@gmail.com`;
  console.log(`--- ROZPOCZYNAM TEST REJESTRACJI ---`);
  console.log(`1. Tworzenie użytkownika: ${email}`);
  
  const tasteProfileData = {
    axis_strength: 0.7,
    axis_bitterness: 0.3,
    axis_fruitiness: 0.5,
    preferred_styles: ['IPA', 'Stout'],
    preferred_countries: ['PL', 'DE'],
    experience_level: 2,
  };

  const { data, error } = await supabase.auth.signUp({
    email,
    password: 'Password123!',
    options: {
      data: {
        display_name: `Test Node`,
        taste_profile: tasteProfileData
      }
    }
  });
  
  if (error) {
    console.error('❌ BŁĄD REJESTRACJI:', error);
    return;
  }
  
  const userId = data.user.id;
  console.log(`✅ Użytkownik utworzony. ID: ${userId}`);
  
  // Wait a second for trigger to complete
  await new Promise(r => setTimeout(r, 1000));
  
  console.log('2. Weryfikacja (SELECT z taste_profiles)...');
  // We need to use service role key to bypass RLS and verify since we don't have a session!
  // BUT wait, can we use anon key to select? RLS might block it!
  // If RLS blocks select for anon, I won't be able to read it without service role.
  // Wait! The user says "Pokaż mi wynik z panelu Supabase...".
  // Let's use service_role key to select it in the script to prove it exists!
}

run();
