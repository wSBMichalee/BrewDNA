const SUPABASE_URL = "https://kskrqpncvqokstcxrugp.supabase.co";
const ANON_KEY = "sb_publishable_6FCPrZ-FRoG4XmuO98nHDA_d_9yr2FQ";

async function run() {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/users?select=*&limit=1`, {
    method: 'GET',
    headers: { 'apikey': ANON_KEY }
  });
  console.log(await res.json());
}
run();
