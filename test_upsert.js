const SUPABASE_URL = "https://kskrqpncvqokstcxrugp.supabase.co";
const ANON_KEY = "sb_publishable_6FCPrZ-FRoG4XmuO98nHDA_d_9yr2FQ";
const userId = "dfafb663-a8e8-43ee-bd23-7a8d9a9162a8";

async function run() {
  const onboardingState = {
    lightStrongValue: 75.5,
    bitterSweetValue: 20.0,
    dryFruityValue: 90.0,
    crispMaltyValue: 10.0,
    selectedStyles: ["IPA", "Stout"],
    selectedCountries: ["Polska", "Belgia"],
    experienceLevel: "expert"
  };

  const payload = {
    user_id: userId,
    axis_strength: onboardingState.lightStrongValue,
    axis_bitterness: onboardingState.bitterSweetValue,
    axis_fruitiness: onboardingState.dryFruityValue,
    axis_maltiness: onboardingState.crispMaltyValue,
    preferred_styles: onboardingState.selectedStyles,
    preferred_countries: onboardingState.selectedCountries,
    experience_level: onboardingState.experienceLevel
  };

  const res = await fetch(`${SUPABASE_URL}/rest/v1/taste_profiles`, {
    method: 'POST',
    headers: {
      'apikey': ANON_KEY,
      'Content-Type': 'application/json',
      'Prefer': 'resolution=merge-duplicates'
    },
    body: JSON.stringify(payload)
  });
  
  if (!res.ok) {
    console.error("Upsert failed:", await res.text());
  } else {
    console.log("Upsert success!");
  }
  
  const fetchRes = await fetch(`${SUPABASE_URL}/rest/v1/taste_profiles?user_id=eq.${userId}`, {
    method: 'GET',
    headers: { 'apikey': ANON_KEY }
  });
  console.log("taste_profiles Data:", JSON.stringify(await fetchRes.json(), null, 2));
}

run();
