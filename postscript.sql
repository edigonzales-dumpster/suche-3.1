CREATE OR REPLACE VIEW agi_mopublic_pub.mopublic_bodenbedeckung_solr_v
AS WITH index_base AS (
         SELECT 'ch.so.agi.av.bodenbedeckung'::text AS subclass,
            mopublic_bodenbedeckung.t_id AS id_in_class,
            concat('EGID: ', mopublic_bodenbedeckung.egid, ' (Gebäude)') AS displaytext,
            mopublic_bodenbedeckung.egid AS part_1,
            (st_asgeojson(st_envelope(mopublic_bodenbedeckung.geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox,
            'Gebäude EGID Nr'::text AS part_3
           FROM agi_mopublic_pub.mopublic_bodenbedeckung
          WHERE mopublic_bodenbedeckung.egid IS NOT NULL
        )
 SELECT array_to_json(ARRAY[index_base.subclass, index_base.id_in_class::text])::text AS id,
    index_base.displaytext AS display,
    index_base.part_1 AS search_1_stem,
    (index_base.part_1 || ' '::text) || index_base.part_3 AS search_3_stem,
    index_base.part_1 AS sort,
    index_base.subclass AS facet,
    index_base.bbox,
    array_to_json(ARRAY['t_id'::text, 'str:n'::text])::text AS idfield_meta
   FROM index_base;


CREATE OR REPLACE VIEW agi_mopublic_pub.mopublic_fixpunkt_solr_v
AS WITH index_base AS (
         SELECT 'ch.so.agi.av.fixpunkte'::text AS subclass,
            mopublic_fixpunkt.t_id AS id_in_class,
            concat('Nr: ', mopublic_fixpunkt.nummer, ' (Fixpunkt)') AS displaytext,
            mopublic_fixpunkt.nummer AS part_1,
            (st_asgeojson(st_envelope(mopublic_fixpunkt.geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox,
            'Fixpunkt Nr'::text AS part_3
           FROM agi_mopublic_pub.mopublic_fixpunkt
          WHERE mopublic_fixpunkt.nummer IS NOT NULL
        )
 SELECT array_to_json(ARRAY[index_base.subclass, index_base.id_in_class::text])::text AS id,
    index_base.displaytext AS display,
    index_base.part_1 AS search_1_stem,
    (index_base.part_1::text || ' '::text) || index_base.part_3 AS search_3_stem,
    index_base.part_1 AS sort,
    index_base.subclass AS facet,
    index_base.bbox,
    array_to_json(ARRAY['t_id'::text, 'str:n'::text])::text AS idfield_meta
   FROM index_base;


CREATE OR REPLACE VIEW agi_mopublic_pub.mopublic_flurname_solr_v
AS WITH index_base AS (
         SELECT 'ch.so.agi.av.nomenklatur.flurnamen'::text AS subclass,
            flurname.t_id AS id_in_class,
            concat(flurname.flurname, ', ', flurname.gemeinde, ' (Flurname)') AS displaytext,
            flurname.flurname AS part_1,
            (st_asgeojson(st_envelope(flurname.geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox,
            concat(flurname.gemeinde, ' Flurname') AS part_3
           FROM agi_mopublic_pub.mopublic_flurname flurname
        )
 SELECT array_to_json(ARRAY[index_base.subclass, index_base.id_in_class::text])::text AS id,
    index_base.displaytext AS display,
    index_base.part_1 AS search_1_stem,
    (index_base.part_1::text || ' '::text) || index_base.part_3 AS search_3_stem,
    index_base.part_1 AS sort,
    index_base.subclass AS facet,
    index_base.bbox,
    array_to_json(ARRAY['t_id'::text, 'str:n'::text])::text AS idfield_meta
   FROM index_base;


CREATE OR REPLACE VIEW agi_mopublic_pub.mopublic_gebaeudeadresse_solr_v
AS WITH index_base AS (
         SELECT 'ch.so.agi.av.gebaeudeadressen.gebaeudeeingaenge'::text AS subclass,
            mopublic_gebaeudeadresse.t_id AS id_in_class,
            concat(mopublic_gebaeudeadresse.strassenname, ' ', mopublic_gebaeudeadresse.hausnummer, ', ', mopublic_gebaeudeadresse.plz, ' ', mopublic_gebaeudeadresse.ortschaft, ' (Adresse)') AS displaytext,
            concat(mopublic_gebaeudeadresse.strassenname, ' ', mopublic_gebaeudeadresse.hausnummer, ' ', mopublic_gebaeudeadresse.plz, ' ', mopublic_gebaeudeadresse.ortschaft) AS part_1,
            (st_asgeojson(st_envelope(mopublic_gebaeudeadresse.lage), 0, 1)::json -> 'bbox'::text)::text AS bbox,
            'Adresse'::text AS part_3
           FROM agi_mopublic_pub.mopublic_gebaeudeadresse
        )
 SELECT array_to_json(ARRAY[index_base.subclass, index_base.id_in_class::text])::text AS id,
    index_base.displaytext AS display,
    index_base.part_1 AS search_1_stem,
    (index_base.part_1 || ' '::text) || index_base.part_3 AS search_3_stem,
    index_base.part_1 AS sort,
    index_base.subclass AS facet,
    index_base.bbox,
    array_to_json(ARRAY['t_id'::text, 'str:n'::text])::text AS idfield_meta
   FROM index_base;


CREATE OR REPLACE VIEW agi_mopublic_pub.mopublic_gelaendename_solr_v
AS WITH index_base AS (
         SELECT 'ch.so.agi.av.nomenklatur.gelaendenamen'::text AS subclass,
            gelaendename.t_id AS id_in_class,
            concat(gelaendename.gelaendename, ', ', gelaendename.gemeinde, ' (Geländename)') AS displaytext,
            gelaendename.gelaendename AS part_1,
            (st_asgeojson(st_envelope(gelaendename.pos), 0, 1)::json -> 'bbox'::text)::text AS bbox,
            concat(gelaendename.gemeinde, ' Geländename') AS part_3
           FROM agi_mopublic_pub.mopublic_gelaendename gelaendename
        )
 SELECT array_to_json(ARRAY[index_base.subclass, index_base.id_in_class::text])::text AS id,
    index_base.displaytext AS display,
    index_base.part_1 AS search_1_stem,
    (index_base.part_1::text || ' '::text) || index_base.part_3 AS search_3_stem,
    index_base.part_1 AS sort,
    index_base.subclass AS facet,
    index_base.bbox,
    array_to_json(ARRAY['t_id'::text, 'str:n'::text])::text AS idfield_meta
   FROM index_base;

CREATE OR REPLACE VIEW agi_mopublic_pub.mopublic_grundstueck_nummer_solr_v
AS WITH index_base AS (
         SELECT 'ch.so.agi.av.grundstuecke.rechtskraeftig'::text AS subclass,
            grundstueck.t_id AS id_in_class,
                CASE
                    WHEN grundstueck.grundbuch::text = grundstueck.gemeinde::text THEN
                    CASE
                        WHEN grundstueck.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('GB-Nr: ', grundstueck.nummer, ' - ', grundstueck.grundbuch, ' (Baurecht)')
                        WHEN grundstueck.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('GB-Nr: ', grundstueck.nummer, ' - ', grundstueck.grundbuch, ' (Quellenrecht)')
                        ELSE concat('GB-Nr: ', grundstueck.nummer, ' - ', grundstueck.grundbuch, ' (Liegenschaft)')
                    END
                    ELSE
                    CASE
                        WHEN grundstueck.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('GB-Nr: ', grundstueck.nummer, ' - ', grundstueck.grundbuch, ' [', grundstueck.gemeinde, '] (Baurecht)')
                        WHEN grundstueck.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('GB-Nr: ', grundstueck.nummer, ' - ', grundstueck.grundbuch, ' [', grundstueck.gemeinde, '] (Quellenrecht)')
                        ELSE concat('GB-Nr: ', grundstueck.nummer, ' - ', grundstueck.grundbuch, ' [', grundstueck.gemeinde, '] (Liegenschaft)')
                    END
                END AS displaytext,
                CASE
                    WHEN grundstueck.grundbuch::text = grundstueck.gemeinde::text THEN concat(grundstueck.nummer, ' ', grundstueck.grundbuch)
                    ELSE concat(grundstueck.nummer, ' ', grundstueck.grundbuch, ' ', grundstueck.gemeinde)
                END AS part_1,
            (st_asgeojson(st_envelope(grundstueck.geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox,
                CASE
                    WHEN grundstueck.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('GB-Nr gbnr Grundstück SDR Baurecht EGRID ', grundstueck.egrid)
                    WHEN grundstueck.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('GB-Nr gbnr Grundstück Quellenrecht EGRID ', grundstueck.egrid)
                    ELSE concat('GB-Nr gbnr Grundstück Parzelle Liegenschaft EGRID ', grundstueck.egrid)
                END AS part_3
           FROM agi_mopublic_pub.mopublic_grundstueck grundstueck
        )
 SELECT array_to_json(ARRAY[index_base.subclass, index_base.id_in_class::text])::text AS id,
    index_base.displaytext AS display,
    index_base.part_1 AS search_1_stem,
    (index_base.part_1 || ' '::text) || index_base.part_3 AS search_3_stem,
    index_base.part_1 AS sort,
    index_base.subclass AS facet,
    index_base.bbox,
    array_to_json(ARRAY['t_id'::text, 'str:n'::text])::text AS idfield_meta
   FROM index_base;

CREATE OR REPLACE VIEW agi_mopublic_pub.mopublic_grundstueck_proj_nummer_solr_v
AS WITH index_base AS (
         SELECT 'ch.so.agi.av.grundstuecke.projektierte'::text AS subclass,
            grundsteuck_proj.t_id AS id_in_class,
                CASE
                    WHEN grundsteuck_proj.grundbuch::text = grundsteuck_proj.gemeinde::text THEN
                    CASE
                        WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('GB-Nr: ', grundsteuck_proj.nummer, ' - ', grundsteuck_proj.grundbuch, ' (Proj. Baurecht)')
                        WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('GB-Nr: ', grundsteuck_proj.nummer, ' - ', grundsteuck_proj.grundbuch, ' (Proj. Quellenrecht)')
                        ELSE concat('GB-Nr: ', grundsteuck_proj.nummer, ' - ', grundsteuck_proj.grundbuch, ' (Proj. Liegenschaft)')
                    END
                    ELSE
                    CASE
                        WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('GB-Nr: ', grundsteuck_proj.nummer, ' - ', grundsteuck_proj.grundbuch, ' [', grundsteuck_proj.gemeinde, '] (Proj. Baurecht)')
                        WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('GB-Nr: ', grundsteuck_proj.nummer, ' - ', grundsteuck_proj.grundbuch, ' [', grundsteuck_proj.gemeinde, '] (Proj. Quellenrecht)')
                        ELSE concat('GB-Nr: ', grundsteuck_proj.nummer, ' - ', grundsteuck_proj.grundbuch, ' [', grundsteuck_proj.gemeinde, '] (Proj. Liegenschaft)')
                    END
                END AS displaytext,
                CASE
                    WHEN grundsteuck_proj.grundbuch::text = grundsteuck_proj.gemeinde::text THEN concat(grundsteuck_proj.nummer, ' ', grundsteuck_proj.grundbuch)
                    ELSE concat(grundsteuck_proj.nummer, ' ', grundsteuck_proj.grundbuch, ' ', grundsteuck_proj.gemeinde)
                END AS part_1,
            (st_asgeojson(st_envelope(grundsteuck_proj.geometrie), 0, 1)::json -> 'bbox'::text)::text AS bbox,
                CASE
                    WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Baurecht'::text THEN concat('GB-Nr gbnr Grundstück Projektiert SDR Baurecht EGRID ', grundsteuck_proj.egrid)
                    WHEN grundsteuck_proj.art_txt::text = 'SelbstRecht.Quellenrecht'::text THEN concat('GB-Nr gbnr Grundstück Projektiert Quellenrecht EGRID ', grundsteuck_proj.egrid)
                    ELSE concat('GB-Nr gbnr Grundstück Projektiert Parzelle Liegenschaft EGRID ', grundsteuck_proj.egrid)
                END AS part_3
           FROM agi_mopublic_pub.mopublic_grundstueck_proj grundsteuck_proj
        )
 SELECT array_to_json(ARRAY[index_base.subclass, index_base.id_in_class::text])::text AS id,
    index_base.displaytext AS display,
    index_base.part_1 AS search_1_stem,
    (index_base.part_1 || ' '::text) || index_base.part_3 AS search_3_stem,
    index_base.part_1 AS sort,
    index_base.subclass AS facet,
    index_base.bbox,
    array_to_json(ARRAY['t_id'::text, 'str:n'::text])::text AS idfield_meta
   FROM index_base;