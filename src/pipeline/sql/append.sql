/*
    Some game entities are dropped during the data cleaning phase, while their recommendations still remain.
    To prevent foreign key violations all orphaned recommendations are also dropped
*/
DELETE FROM public."RecommendationsAppend"
WHERE app_id NOT IN (SELECT app_id FROM public."Games");

-- Syncing data from `append` tables into the `master` tables
INSERT INTO public."Users" (userprofile, products)
SELECT userprofile, products
FROM public."UsersAppend"
ON CONFLICT (userprofile)
DO NOTHING;

INSERT INTO public."Games" (app_id, title, description, tags, date_release, rating, positive_ratio, user_reviews, price_final, price_original, discount, win, mac, linux, steam_deck)
SELECT app_id, title, description, tags, date_release, rating, positive_ratio, user_reviews, price_final, price_original, discount, win, mac, linux, steam_deck
FROM public."GamesAppend"
ON CONFLICT (app_id)
DO NOTHING;

INSERT INTO public."Recommendations" (app_id, userprofile, date, is_recommended, helpful, funny, hours)
SELECT app_id, userprofile, date, is_recommended, helpful, funny, hours
FROM public."RecommendationsAppend"
ON CONFLICT (app_id, userprofile, date)
DO NOTHING;

-- Removing temporary `append` tables
DROP TABLE IF EXISTS public."UsersAppend";
DROP TABLE IF EXISTS public."GamesAppend";
DROP TABLE IF EXISTS public."RecommendationsAppend";

