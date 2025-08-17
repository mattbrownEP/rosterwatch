-- Complete database migration script for production
-- Run this in your production database pane

-- First, clear existing data (optional)
DELETE FROM monitored_url;

-- Insert all 45 URLs from development database
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Alabama A&M Athletics', 'https://aamusports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 00:59:12.049158'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Alabama State University', 'https://bamastatesports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:01:55.026108'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Alcorn State', 'https://alcornsports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:02:21.765627'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Appalachian State', 'https://appstatesports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:02:56.18157'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Arizona State', 'https://thesundevils.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:03:44.612793'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Arkansas State University', 'https://astateredwolves.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:04:23.273818'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Auburn', 'https://auburntigers.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:04:55.870338'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Austin Peay', 'https://letsgopeay.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:05:25.300501'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Arizona', 'https://arizonawildcats.com/sports/2007/8/1/207969432.aspx', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:05:56.575447'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Ball State', 'https://ballstatesports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:07:02.835955'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Binghamton', 'https://binghamtonbearcats.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:07:14.84047'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Boise State', 'https://broncosports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:10:06.360484'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Bowling Green', 'https://bgsufalcons.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:10:29.450648'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Cal Poly', 'https://gopoly.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:11:00.892915'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Cal State Bakersfield', 'https://gorunners.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:12:04.447461'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Fresno State', 'https://gobulldogs.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:12:34.111104'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Cal State Fullerton', 'https://fullertontitans.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:14:25.960817'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Cal State Northridge', 'https://gomatadors.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:15:12.247791'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Sacramento State', 'https://hornetsports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:15:38.663298'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Central Connecticut State University', 'https://ccsubluedevils.com/athletics/directory/index', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:16:13.329487'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Central Michigan', 'https://cmuchippewas.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:16:53.611556'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Chicago State', 'https://www.gocsucougars.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:17:19.235339'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Clemson', 'https://clemsontigers.com/staff-directory/', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:18:09.30685'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Cleveland State', 'https://csuvikings.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:18:33.594578'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Coastal Carolina', 'https://goccusports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:18:56.413'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('College of Charleston', 'https://cofcsports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:30:56.329141'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Colorado State', 'https://csurams.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:31:25.03895'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Coppin State', 'https://coppinstatesports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:31:37.923926'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Colorado', 'https://cubuffs.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:32:18.512828'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('ECU', 'https://ecupirates.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:32:41.824438'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('ETSU', 'https://etsubucs.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:43:43.352006'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('East Texas A&M University', 'https://lionathletics.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:44:44.810401'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Eastern Illinois', 'https://eiupanthers.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:45:22.123439'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('EKU', 'https://ekusports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:45:47.853122'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Eastern Michigan', 'https://emueagles.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:46:17.047604'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Eastern Washington University', 'https://goeags.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:46:45.737955'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('FAMU', 'https://famuathletics.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:48:45.355135'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('FAU', 'https://fausports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:49:35.867558'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Florida Gulf Coast', 'https://fgcuathletics.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:50:29.525338'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Florida International', 'https://fiusports.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:50:53.952216'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('George Mason', 'https://gomason.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 01:53:16.97477'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Georgia Tech', 'https://ramblinwreck.com/staff-directory/', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 02:00:25.549252'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Georgia Southern', 'https://gseagles.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 02:00:48.161427'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Georgia State', 'https://georgiastatesports.com/staff-directory', 'Matt@ExtraPointsMB.com', 'GA', true, '2025-08-17 02:01:13.887086'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Georgia', 'https://georgiadogs.com/staff-directory', 'Matt@ExtraPointsMB.com', 'GA', true, '2025-08-17 02:01:53.238716'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Grambling', 'https://gsutigers.com/staff-directory', 'Matt@ExtraPointsMB.com', 'TX', true, '2025-08-17 02:25:49.584931'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Idaho State', 'https://isubengals.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 02:26:18.235648'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Illinois State', 'https://goredbirds.com/staff-directory?path=general', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 02:26:51.236793'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Indiana State', 'https://gosycamores.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 02:27:16.78516'::timestamp);
INSERT INTO monitored_url (name, url, email, state, is_active, created_at) VALUES ('Indiana', 'https://iuhoosiers.com/staff-directory', 'Matt@ExtraPointsMB.com', NULL, true, '2025-08-17 02:27:54.857589'::timestamp);

-- Verify the migration
SELECT COUNT(*) as total_urls FROM monitored_url WHERE is_active = true;
SELECT name FROM monitored_url ORDER BY name;