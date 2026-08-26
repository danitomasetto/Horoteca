# SUPABASE — CATÁLOGO VERIFICADO — 26/08/2026

## Finalidade

Snapshot técnico somente leitura do catálogo do projeto Horoteca
(`nlkhbhgzscpdistzuyod`), preparado para permitir a reconstrução fiel da
baseline no Git sem inventar definições.

- Data da leitura: 26/08/2026.
- Escopo: schema `public`, função pública própria e bucket `watch-photos`.
- Operação realizada: somente consultas `SELECT` e leitura de metadados.
- Nenhuma tabela, dado, política, função, migration ou objeto do Storage foi alterado.
- Dados pessoais, UUID de usuário, credenciais e chaves não foram incluídos.
- Este arquivo é evidência técnica de entrada; não é migration e não deve ser executado como SQL.

## Alerta atual do Supabase

Novas tabelas expostas pela Data API precisam de `GRANT` explícito além de
RLS e políticas. A futura Fila de Cadastro deverá conceder apenas
`SELECT, INSERT, UPDATE, DELETE` a `authenticated`, sem grants equivalentes
para `anon`, seguindo o padrão atual da Horoteca.

## 1. Tabelas, colunas, tipos, nulabilidade, identidades e relacionamentos

```json
{
  "tables": [
    {
      "name": "public.watches",
      "rls_enabled": true,
      "rows": 1,
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "brand",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "model",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "reference_number",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "movement_type",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "case_material",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "dial_color",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "strap_material",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "purchase_date",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "purchase_price",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "notes",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "image_uri",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "qr_code",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "horoteca_code",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "order_number",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "order_item_number",
          "data_type": "integer",
          "format": "int4",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "marketplace",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "marketplace_item_id",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "seller_name",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "purchase_currency",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "purchase_amount_original",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "purchase_total_brl",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "payment_method",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "estimated_value",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "estimated_value_date",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "manufacture_year",
          "data_type": "integer",
          "format": "int4",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "movement_caliber",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "condition",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "brand_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "watch_model_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "movement_caliber_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "serial_number",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "case_code",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "dial_code",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "movement_description",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "jewels",
          "data_type": "smallint",
          "format": "int2",
          "options": [
            "nullable",
            "updatable"
          ],
          "check": "jewels IS NULL OR jewels >= 0 AND jewels <= 200"
        },
        {
          "name": "complications",
          "data_type": "ARRAY",
          "format": "_text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "manufacture_country",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "manufacture_year_is_estimated",
          "data_type": "boolean",
          "format": "bool",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "production_period_start_year",
          "data_type": "smallint",
          "format": "int2",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "production_period_end_year",
          "data_type": "smallint",
          "format": "int2",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "diameter_mm",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "case_thickness_mm",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "lug_to_lug_mm",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "lug_width_mm",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "case_finish",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "case_color",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "case_shape",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "dial_description",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "dial_inscriptions",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "indices_description",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "hands_description",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "crystal_material",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "crystal_condition",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "crown_description",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "caseback_description",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "caseback_inscriptions",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "strap_description",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "clasp_type",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "strap_originality",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "dial_originality",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "component_originality",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "function_status",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "accuracy_seconds_per_day",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "accuracy_notes",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "known_defects",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "water_resistance",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "source_document_url",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "updated_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "watch_type",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "display_type",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "intended_audience",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "bezel_type",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "bezel_material",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "bezel_color",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "strap_color",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "has_original_box",
          "data_type": "boolean",
          "format": "bool",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "has_original_papers",
          "data_type": "boolean",
          "format": "bool",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "included_accessories",
          "data_type": "ARRAY",
          "format": "_text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "is_customized",
          "data_type": "boolean",
          "format": "bool",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "customization_description",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "features",
          "data_type": "ARRAY",
          "format": "_text",
          "options": [
            "nullable",
            "updatable"
          ]
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "watches_brand_id_fkey",
          "source_table": "public.watches",
          "source_columns": [
            "brand_id"
          ],
          "target_table": "public.brands",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watches_user_id_fkey",
          "source_table": "public.watches",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "maintenance_logs_watch_id_fkey",
          "source_table": "public.maintenance_logs",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_claims_watch_id_fkey",
          "source_table": "public.watch_claims",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_photo_links_watch_id_fkey",
          "source_table": "public.watch_photo_links",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_sources_watch_id_fkey",
          "source_table": "public.watch_sources",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_events_watch_id_fkey",
          "source_table": "public.watch_events",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "expense_allocations_watch_id_fkey",
          "source_table": "public.expense_allocations",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "expenses_watch_id_fkey",
          "source_table": "public.expenses",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "acquisition_items_watch_id_fkey",
          "source_table": "public.acquisition_items",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watches_movement_caliber_id_fkey",
          "source_table": "public.watches",
          "source_columns": [
            "movement_caliber_id"
          ],
          "target_table": "public.movement_calibers",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watches_watch_model_id_fkey",
          "source_table": "public.watches",
          "source_columns": [
            "watch_model_id"
          ],
          "target_table": "public.watch_models",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_photos_watch_id_fkey",
          "source_table": "public.watch_photos",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.maintenance_logs",
      "rls_enabled": true,
      "rows": 1,
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "watch_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "service_date",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "description",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "service_provider",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "cost",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "next_service_due",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "event_type",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ],
          "default_value": "'manutencao'::text"
        },
        {
          "name": "expense_category",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "currency",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ],
          "default_value": "'BRL'::text"
        },
        {
          "name": "amount_original",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "amount_brl",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "event_date",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "notes",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "updated_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "maintenance_logs_watch_id_fkey",
          "source_table": "public.maintenance_logs",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "maintenance_logs_user_id_fkey",
          "source_table": "public.maintenance_logs",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.brands",
      "rls_enabled": true,
      "rows": 1,
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "name",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "country",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "founded_year",
          "data_type": "integer",
          "format": "int4",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "founder",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "history",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "milestones",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "technologies",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "curiosities",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "logo_path",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "updated_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "brands_user_id_fkey",
          "source_table": "public.brands",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watches_brand_id_fkey",
          "source_table": "public.watches",
          "source_columns": [
            "brand_id"
          ],
          "target_table": "public.brands",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_models_brand_id_fkey",
          "source_table": "public.watch_models",
          "source_columns": [
            "brand_id"
          ],
          "target_table": "public.brands",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.watch_photos",
      "rls_enabled": true,
      "rows": 0,
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "watch_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "storage_path",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "caption",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "is_cover",
          "data_type": "boolean",
          "format": "bool",
          "options": [
            "updatable"
          ],
          "default_value": "false"
        },
        {
          "name": "sort_order",
          "data_type": "integer",
          "format": "int4",
          "options": [
            "updatable"
          ],
          "default_value": "0"
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "acquisition_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "photo_type",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "source_type",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "source_url",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "evidence_classification",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ],
          "check": "evidence_classification IS NULL OR (evidence_classification = ANY (ARRAY['document_confirmed'::text, 'seller_statement'::text, 'visual_observation'::text, 'researched'::text, 'estimated'::text, 'missing'::text, 'inconsistent'::text]))"
        },
        {
          "name": "notes",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "updated_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "watch_photo_links_photo_id_fkey",
          "source_table": "public.watch_photo_links",
          "source_columns": [
            "photo_id"
          ],
          "target_table": "public.watch_photos",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_photos_acquisition_id_fkey",
          "source_table": "public.watch_photos",
          "source_columns": [
            "acquisition_id"
          ],
          "target_table": "public.acquisitions",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_photos_user_id_fkey",
          "source_table": "public.watch_photos",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_photos_watch_id_fkey",
          "source_table": "public.watch_photos",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.watch_models",
      "rls_enabled": true,
      "rows": 1,
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "brand_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "model_name",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "line_name",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "reference_family",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "launch_year",
          "data_type": "smallint",
          "format": "int2",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "production_start_year",
          "data_type": "smallint",
          "format": "int2",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "production_end_year",
          "data_type": "smallint",
          "format": "int2",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "designer",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "creation_context",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "history",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "notable_features",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "historical_importance",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "history_sources",
          "data_type": "jsonb",
          "format": "jsonb",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "reviewed_at",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "updated_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "watch_models_brand_id_fkey",
          "source_table": "public.watch_models",
          "source_columns": [
            "brand_id"
          ],
          "target_table": "public.brands",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_models_user_id_fkey",
          "source_table": "public.watch_models",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watches_watch_model_id_fkey",
          "source_table": "public.watches",
          "source_columns": [
            "watch_model_id"
          ],
          "target_table": "public.watch_models",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.movement_calibers",
      "rls_enabled": true,
      "rows": 0,
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "manufacturer",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "caliber_code",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "movement_type",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "jewels",
          "data_type": "smallint",
          "format": "int2",
          "options": [
            "nullable",
            "updatable"
          ],
          "check": "jewels IS NULL OR jewels >= 0 AND jewels <= 200"
        },
        {
          "name": "complications",
          "data_type": "ARRAY",
          "format": "_text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "production_start_year",
          "data_type": "smallint",
          "format": "int2",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "production_end_year",
          "data_type": "smallint",
          "format": "int2",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "technical_description",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "history",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "historical_importance",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "history_sources",
          "data_type": "jsonb",
          "format": "jsonb",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "reviewed_at",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "updated_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "frequency_vph",
          "data_type": "integer",
          "format": "int4",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "power_reserve_hours",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "movement_diameter_mm",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "movement_thickness_mm",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "has_manual_winding",
          "data_type": "boolean",
          "format": "bool",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "has_hacking_seconds",
          "data_type": "boolean",
          "format": "bool",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "quickset_features",
          "data_type": "ARRAY",
          "format": "_text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "shock_protection",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "escapement_type",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "winding_description",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "watches_movement_caliber_id_fkey",
          "source_table": "public.watches",
          "source_columns": [
            "movement_caliber_id"
          ],
          "target_table": "public.movement_calibers",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "movement_calibers_user_id_fkey",
          "source_table": "public.movement_calibers",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.acquisitions",
      "rls_enabled": true,
      "rows": 1,
      "comment": "Order or lot level purchase information.",
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "marketplace",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "seller_name",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "order_number",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "purchase_date",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "purchase_payment_date",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "taxes_payment_date",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "shipped_date",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "received_date",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "payment_method",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "carrier",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "tracking_number",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "source_document_url",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "notes",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "updated_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "estimated_delivery_date",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "source_document_name",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "watch_photos_acquisition_id_fkey",
          "source_table": "public.watch_photos",
          "source_columns": [
            "acquisition_id"
          ],
          "target_table": "public.acquisitions",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "acquisitions_user_id_fkey",
          "source_table": "public.acquisitions",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "acquisition_items_acquisition_id_fkey",
          "source_table": "public.acquisition_items",
          "source_columns": [
            "acquisition_id"
          ],
          "target_table": "public.acquisitions",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_events_acquisition_id_fkey",
          "source_table": "public.watch_events",
          "source_columns": [
            "acquisition_id"
          ],
          "target_table": "public.acquisitions",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "expenses_acquisition_id_fkey",
          "source_table": "public.expenses",
          "source_columns": [
            "acquisition_id"
          ],
          "target_table": "public.acquisitions",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_sources_acquisition_id_fkey",
          "source_table": "public.watch_sources",
          "source_columns": [
            "acquisition_id"
          ],
          "target_table": "public.acquisitions",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.acquisition_items",
      "rls_enabled": true,
      "rows": 1,
      "comment": "One physical watch within an acquisition or lot.",
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "acquisition_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "watch_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "updatable",
            "unique"
          ]
        },
        {
          "name": "item_sequence",
          "data_type": "integer",
          "format": "int4",
          "options": [
            "updatable"
          ],
          "check": "item_sequence > 0"
        },
        {
          "name": "marketplace_item_id",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "visual_position",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "individual_price_original",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "currency",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "individual_price_brl",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "allocation_basis",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "notes",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "updated_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "listing_title",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "listing_url",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "listing_category",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "seller_condition_label",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "seller_condition_description",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "listing_quantity",
          "data_type": "integer",
          "format": "int4",
          "options": [
            "nullable",
            "updatable"
          ],
          "check": "listing_quantity IS NULL OR listing_quantity > 0"
        },
        {
          "name": "listing_language",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "listing_specifics",
          "data_type": "jsonb",
          "format": "jsonb",
          "options": [
            "updatable"
          ],
          "default_value": "'{}'::jsonb",
          "comment": "Exact marketplace key/value specifics not promoted to canonical columns."
        },
        {
          "name": "listing_captured_at",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "acquisition_items_watch_id_fkey",
          "source_table": "public.acquisition_items",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "acquisition_items_acquisition_id_fkey",
          "source_table": "public.acquisition_items",
          "source_columns": [
            "acquisition_id"
          ],
          "target_table": "public.acquisitions",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "acquisition_items_user_id_fkey",
          "source_table": "public.acquisition_items",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.expenses",
      "rls_enabled": true,
      "rows": 4,
      "comment": "Documentary expense totals before allocation.",
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "acquisition_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "watch_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "category",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ],
          "check": "category = ANY (ARRAY['product'::text, 'freight'::text, 'tax'::text, 'fee'::text, 'carrier'::text, 'maintenance'::text, 'parts'::text, 'strap'::text, 'other'::text])"
        },
        {
          "name": "description",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "expense_date",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "currency",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "amount_original",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "exchange_rate",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "amount_brl",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "is_shared",
          "data_type": "boolean",
          "format": "bool",
          "options": [
            "updatable"
          ],
          "default_value": "false"
        },
        {
          "name": "allocation_method",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "source_reference",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "notes",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "updated_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "expenses_user_id_fkey",
          "source_table": "public.expenses",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "expenses_watch_id_fkey",
          "source_table": "public.expenses",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "expenses_acquisition_id_fkey",
          "source_table": "public.expenses",
          "source_columns": [
            "acquisition_id"
          ],
          "target_table": "public.acquisitions",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "expense_allocations_expense_id_fkey",
          "source_table": "public.expense_allocations",
          "source_columns": [
            "expense_id"
          ],
          "target_table": "public.expenses",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_events_expense_id_fkey",
          "source_table": "public.watch_events",
          "source_columns": [
            "expense_id"
          ],
          "target_table": "public.expenses",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.expense_allocations",
      "rls_enabled": true,
      "rows": 4,
      "comment": "Per-watch allocation preserving rounding differences.",
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "expense_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "watch_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "amount_original_allocated",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "amount_brl_allocated",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "rounding_adjustment_brl",
          "data_type": "numeric",
          "format": "numeric",
          "options": [
            "updatable"
          ],
          "default_value": "0"
        },
        {
          "name": "allocation_basis",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "expense_allocations_watch_id_fkey",
          "source_table": "public.expense_allocations",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "expense_allocations_expense_id_fkey",
          "source_table": "public.expense_allocations",
          "source_columns": [
            "expense_id"
          ],
          "target_table": "public.expenses",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "expense_allocations_user_id_fkey",
          "source_table": "public.expense_allocations",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.watch_events",
      "rls_enabled": true,
      "rows": 6,
      "comment": "Chronological lifecycle and maintenance events.",
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "watch_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "acquisition_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "event_type",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ],
          "check": "event_type = ANY (ARRAY['purchase'::text, 'payment'::text, 'shipment'::text, 'customs'::text, 'receipt'::text, 'inspection'::text, 'maintenance'::text, 'parts_replacement'::text, 'valuation'::text, 'sale'::text, 'retirement'::text, 'other'::text])"
        },
        {
          "name": "event_date",
          "data_type": "date",
          "format": "date",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "description",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "provider",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "expense_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "parts_replaced",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "function_before",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "function_after",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "next_service_due",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "notes",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "updated_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "watch_events_watch_id_fkey",
          "source_table": "public.watch_events",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_events_expense_id_fkey",
          "source_table": "public.watch_events",
          "source_columns": [
            "expense_id"
          ],
          "target_table": "public.expenses",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_events_acquisition_id_fkey",
          "source_table": "public.watch_events",
          "source_columns": [
            "acquisition_id"
          ],
          "target_table": "public.acquisitions",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_events_user_id_fkey",
          "source_table": "public.watch_events",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.watch_sources",
      "rls_enabled": true,
      "rows": 7,
      "comment": "Documentary, visual and researched evidence.",
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "watch_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "acquisition_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "source_type",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "source_name",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "source_url",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "evidence_classification",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ],
          "check": "evidence_classification = ANY (ARRAY['document_confirmed'::text, 'seller_statement'::text, 'visual_observation'::text, 'researched'::text, 'estimated'::text, 'missing'::text, 'inconsistent'::text])"
        },
        {
          "name": "confidence_percent",
          "data_type": "smallint",
          "format": "int2",
          "options": [
            "nullable",
            "updatable"
          ],
          "check": "confidence_percent IS NULL OR confidence_percent >= 0 AND confidence_percent <= 100"
        },
        {
          "name": "excerpt",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "notes",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "accessed_at",
          "data_type": "date",
          "format": "date",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "watch_sources_user_id_fkey",
          "source_table": "public.watch_sources",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_sources_acquisition_id_fkey",
          "source_table": "public.watch_sources",
          "source_columns": [
            "acquisition_id"
          ],
          "target_table": "public.acquisitions",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_claims_source_id_fkey",
          "source_table": "public.watch_claims",
          "source_columns": [
            "source_id"
          ],
          "target_table": "public.watch_sources",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_sources_watch_id_fkey",
          "source_table": "public.watch_sources",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.watch_photo_links",
      "rls_enabled": true,
      "rows": 0,
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "photo_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "watch_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "visual_position",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "notes",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "watch_photo_links_watch_id_fkey",
          "source_table": "public.watch_photo_links",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_photo_links_user_id_fkey",
          "source_table": "public.watch_photo_links",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_photo_links_photo_id_fkey",
          "source_table": "public.watch_photo_links",
          "source_columns": [
            "photo_id"
          ],
          "target_table": "public.watch_photos",
          "target_columns": [
            "id"
          ]
        }
      ]
    },
    {
      "name": "public.watch_claims",
      "rls_enabled": true,
      "rows": 6,
      "comment": "Field-level assertions preserved separately from canonical confirmed facts.",
      "columns": [
        {
          "name": "id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "identity",
            "updatable"
          ],
          "identity_generation": "BY DEFAULT"
        },
        {
          "name": "user_id",
          "data_type": "uuid",
          "format": "uuid",
          "options": [
            "updatable"
          ],
          "default_value": "auth.uid()"
        },
        {
          "name": "watch_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "updatable"
          ]
        },
        {
          "name": "source_id",
          "data_type": "bigint",
          "format": "int8",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "field_name",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ],
          "check": "btrim(field_name) <> ''::text"
        },
        {
          "name": "asserted_value",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ],
          "check": "btrim(asserted_value) <> ''::text"
        },
        {
          "name": "normalized_value",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "evidence_classification",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ],
          "check": "evidence_classification = ANY (ARRAY['document_confirmed'::text, 'seller_statement'::text, 'visual_observation'::text, 'researched'::text, 'estimated'::text, 'missing'::text, 'inconsistent'::text])"
        },
        {
          "name": "verification_status",
          "data_type": "text",
          "format": "text",
          "options": [
            "updatable"
          ],
          "default_value": "'pending'::text",
          "check": "verification_status = ANY (ARRAY['pending'::text, 'accepted'::text, 'rejected'::text, 'superseded'::text])"
        },
        {
          "name": "confidence_percent",
          "data_type": "smallint",
          "format": "int2",
          "options": [
            "nullable",
            "updatable"
          ],
          "check": "confidence_percent IS NULL OR confidence_percent >= 0 AND confidence_percent <= 100"
        },
        {
          "name": "claim_context",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "notes",
          "data_type": "text",
          "format": "text",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "reviewed_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "nullable",
            "updatable"
          ]
        },
        {
          "name": "created_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        },
        {
          "name": "updated_at",
          "data_type": "timestamp with time zone",
          "format": "timestamptz",
          "options": [
            "updatable"
          ],
          "default_value": "now()"
        }
      ],
      "primary_keys": [
        "id"
      ],
      "foreign_key_constraints": [
        {
          "name": "watch_claims_user_id_fkey",
          "source_table": "public.watch_claims",
          "source_columns": [
            "user_id"
          ],
          "target_table": "auth.users",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_claims_watch_id_fkey",
          "source_table": "public.watch_claims",
          "source_columns": [
            "watch_id"
          ],
          "target_table": "public.watches",
          "target_columns": [
            "id"
          ]
        },
        {
          "name": "watch_claims_source_id_fkey",
          "source_table": "public.watch_claims",
          "source_columns": [
            "source_id"
          ],
          "target_table": "public.watch_sources",
          "target_columns": [
            "id"
          ]
        }
      ]
    }
  ]
}
```

## 2. Relações e sequences

```json
{
  "relations": [
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "acquisition_items",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": "One physical watch within an acquisition or lot.",
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "acquisition_items_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "acquisitions",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": "Order or lot level purchase information.",
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "acquisitions_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "brands",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "brands_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "expense_allocations",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": "Per-watch allocation preserving rounding differences.",
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "expense_allocations_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "expenses",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": "Documentary expense totals before allocation.",
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "expenses_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "maintenance_logs",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "maintenance_logs_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "movement_calibers",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "movement_calibers_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "watch_claims",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": "Field-level assertions preserved separately from canonical confirmed facts.",
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "watch_claims_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "watch_events",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": "Chronological lifecycle and maintenance events.",
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "watch_events_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "watch_models",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "watch_models_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "watch_photo_links",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "watch_photo_links_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "watch_photos",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "watch_photos_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "watch_sources",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": "Documentary, visual and researched evidence.",
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "watch_sources_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "r",
      "owner_name": "postgres",
      "relation_name": "watches",
      "relpersistence": "p",
      "relrowsecurity": true,
      "relation_comment": null,
      "relforcerowsecurity": false
    },
    {
      "relkind": "S",
      "owner_name": "postgres",
      "relation_name": "watches_id_seq",
      "relpersistence": "p",
      "relrowsecurity": false,
      "relation_comment": null,
      "relforcerowsecurity": false
    }
  ],
  "sequences": [
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": 1,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "acquisition_items_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": 1,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "acquisitions_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": 1,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "brands_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": 4,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "expense_allocations_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": 4,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "expenses_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": 1,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "maintenance_logs_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": null,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "movement_calibers_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": 6,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "watch_claims_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": 6,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "watch_events_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": 1,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "watch_models_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": null,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "watch_photo_links_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": null,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "watch_photos_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": 7,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "watch_sources_id_seq",
      "sequenceowner": "postgres"
    },
    {
      "cycle": false,
      "data_type": "bigint",
      "max_value": 9223372036854776000,
      "min_value": 1,
      "cache_size": 1,
      "last_value": 1,
      "schemaname": "public",
      "start_value": 1,
      "increment_by": 1,
      "sequencename": "watches_id_seq",
      "sequenceowner": "postgres"
    }
  ],
  "sequence_dependencies": [
    {
      "deptype": "i",
      "table_name": "acquisition_items",
      "column_name": "id",
      "sequence_name": "acquisition_items_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "acquisitions",
      "column_name": "id",
      "sequence_name": "acquisitions_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "brands",
      "column_name": "id",
      "sequence_name": "brands_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "expense_allocations",
      "column_name": "id",
      "sequence_name": "expense_allocations_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "expenses",
      "column_name": "id",
      "sequence_name": "expenses_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "maintenance_logs",
      "column_name": "id",
      "sequence_name": "maintenance_logs_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "movement_calibers",
      "column_name": "id",
      "sequence_name": "movement_calibers_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "watch_claims",
      "column_name": "id",
      "sequence_name": "watch_claims_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "watch_events",
      "column_name": "id",
      "sequence_name": "watch_events_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "watch_models",
      "column_name": "id",
      "sequence_name": "watch_models_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "watch_photo_links",
      "column_name": "id",
      "sequence_name": "watch_photo_links_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "watch_photos",
      "column_name": "id",
      "sequence_name": "watch_photos_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "watch_sources",
      "column_name": "id",
      "sequence_name": "watch_sources_id_seq"
    },
    {
      "deptype": "i",
      "table_name": "watches",
      "column_name": "id",
      "sequence_name": "watches_id_seq"
    }
  ]
}
```

## 3. Constraints

```json
[
  {
    "definition": "CHECK (listing_quantity IS NULL OR listing_quantity > 0)",
    "table_name": "acquisition_items",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "acquisition_items_listing_quantity_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (item_sequence > 0)",
    "table_name": "acquisition_items",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "acquisition_items_sequence_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (acquisition_id) REFERENCES acquisitions(id) ON DELETE CASCADE",
    "table_name": "acquisition_items",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "acquisition_items_acquisition_id_fkey",
    "constraint_type": "f",
    "referenced_table": "acquisitions",
    "referenced_schema": "public"
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE",
    "table_name": "acquisition_items",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "acquisition_items_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE CASCADE",
    "table_name": "acquisition_items",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "acquisition_items_watch_id_fkey",
    "constraint_type": "f",
    "referenced_table": "watches",
    "referenced_schema": "public"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "acquisition_items",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "acquisition_items_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "UNIQUE (acquisition_id, item_sequence)",
    "table_name": "acquisition_items",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "acquisition_items_acquisition_sequence_key",
    "constraint_type": "u",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "UNIQUE (watch_id)",
    "table_name": "acquisition_items",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "acquisition_items_watch_key",
    "constraint_type": "u",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE",
    "table_name": "acquisitions",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "acquisitions_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "acquisitions",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "acquisitions_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id)",
    "table_name": "brands",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "brands_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "brands",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "brands_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "UNIQUE (user_id, name)",
    "table_name": "brands",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "brands_user_id_name_key",
    "constraint_type": "u",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK ((amount_original_allocated IS NULL OR amount_original_allocated >= 0::numeric) AND amount_brl_allocated >= 0::numeric)",
    "table_name": "expense_allocations",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expense_allocations_amounts_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (expense_id) REFERENCES expenses(id) ON DELETE CASCADE",
    "table_name": "expense_allocations",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expense_allocations_expense_id_fkey",
    "constraint_type": "f",
    "referenced_table": "expenses",
    "referenced_schema": "public"
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE",
    "table_name": "expense_allocations",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expense_allocations_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE CASCADE",
    "table_name": "expense_allocations",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expense_allocations_watch_id_fkey",
    "constraint_type": "f",
    "referenced_table": "watches",
    "referenced_schema": "public"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "expense_allocations",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expense_allocations_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "UNIQUE (expense_id, watch_id)",
    "table_name": "expense_allocations",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expense_allocations_expense_watch_key",
    "constraint_type": "u",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (amount_original >= 0::numeric AND (amount_brl IS NULL OR amount_brl >= 0::numeric) AND (exchange_rate IS NULL OR exchange_rate > 0::numeric))",
    "table_name": "expenses",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expenses_amounts_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (category = ANY (ARRAY['product'::text, 'freight'::text, 'tax'::text, 'fee'::text, 'carrier'::text, 'maintenance'::text, 'parts'::text, 'strap'::text, 'other'::text]))",
    "table_name": "expenses",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expenses_category_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (acquisition_id IS NOT NULL OR watch_id IS NOT NULL)",
    "table_name": "expenses",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expenses_owner_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (acquisition_id) REFERENCES acquisitions(id) ON DELETE CASCADE",
    "table_name": "expenses",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expenses_acquisition_id_fkey",
    "constraint_type": "f",
    "referenced_table": "acquisitions",
    "referenced_schema": "public"
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE",
    "table_name": "expenses",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expenses_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE CASCADE",
    "table_name": "expenses",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expenses_watch_id_fkey",
    "constraint_type": "f",
    "referenced_table": "watches",
    "referenced_schema": "public"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "expenses",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "expenses_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id)",
    "table_name": "maintenance_logs",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "maintenance_logs_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE CASCADE",
    "table_name": "maintenance_logs",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "maintenance_logs_watch_id_fkey",
    "constraint_type": "f",
    "referenced_table": "watches",
    "referenced_schema": "public"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "maintenance_logs",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "maintenance_logs_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (jewels IS NULL OR jewels >= 0 AND jewels <= 200)",
    "table_name": "movement_calibers",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "movement_calibers_jewels_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK ((frequency_vph IS NULL OR frequency_vph > 0) AND (power_reserve_hours IS NULL OR power_reserve_hours > 0::numeric) AND (movement_diameter_mm IS NULL OR movement_diameter_mm > 0::numeric) AND (movement_thickness_mm IS NULL OR movement_thickness_mm > 0::numeric))",
    "table_name": "movement_calibers",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "movement_calibers_specs_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (production_start_year IS NULL OR production_end_year IS NULL OR production_start_year <= production_end_year)",
    "table_name": "movement_calibers",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "movement_calibers_years_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE",
    "table_name": "movement_calibers",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "movement_calibers_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "movement_calibers",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "movement_calibers_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (btrim(asserted_value) <> ''::text)",
    "table_name": "watch_claims",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_claims_asserted_value_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (evidence_classification = ANY (ARRAY['document_confirmed'::text, 'seller_statement'::text, 'visual_observation'::text, 'researched'::text, 'estimated'::text, 'missing'::text, 'inconsistent'::text]))",
    "table_name": "watch_claims",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_claims_classification_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (confidence_percent IS NULL OR confidence_percent >= 0 AND confidence_percent <= 100)",
    "table_name": "watch_claims",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_claims_confidence_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (btrim(field_name) <> ''::text)",
    "table_name": "watch_claims",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_claims_field_name_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (verification_status = ANY (ARRAY['pending'::text, 'accepted'::text, 'rejected'::text, 'superseded'::text]))",
    "table_name": "watch_claims",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_claims_status_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (source_id) REFERENCES watch_sources(id) ON DELETE SET NULL",
    "table_name": "watch_claims",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_claims_source_id_fkey",
    "constraint_type": "f",
    "referenced_table": "watch_sources",
    "referenced_schema": "public"
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE",
    "table_name": "watch_claims",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_claims_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE CASCADE",
    "table_name": "watch_claims",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_claims_watch_id_fkey",
    "constraint_type": "f",
    "referenced_table": "watches",
    "referenced_schema": "public"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "watch_claims",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_claims_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (watch_id IS NOT NULL OR acquisition_id IS NOT NULL)",
    "table_name": "watch_events",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_events_owner_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (event_type = ANY (ARRAY['purchase'::text, 'payment'::text, 'shipment'::text, 'customs'::text, 'receipt'::text, 'inspection'::text, 'maintenance'::text, 'parts_replacement'::text, 'valuation'::text, 'sale'::text, 'retirement'::text, 'other'::text]))",
    "table_name": "watch_events",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_events_type_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (acquisition_id) REFERENCES acquisitions(id) ON DELETE CASCADE",
    "table_name": "watch_events",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_events_acquisition_id_fkey",
    "constraint_type": "f",
    "referenced_table": "acquisitions",
    "referenced_schema": "public"
  },
  {
    "definition": "FOREIGN KEY (expense_id) REFERENCES expenses(id) ON DELETE SET NULL",
    "table_name": "watch_events",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_events_expense_id_fkey",
    "constraint_type": "f",
    "referenced_table": "expenses",
    "referenced_schema": "public"
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE",
    "table_name": "watch_events",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_events_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE CASCADE",
    "table_name": "watch_events",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_events_watch_id_fkey",
    "constraint_type": "f",
    "referenced_table": "watches",
    "referenced_schema": "public"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "watch_events",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_events_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (production_start_year IS NULL OR production_end_year IS NULL OR production_start_year <= production_end_year)",
    "table_name": "watch_models",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_models_years_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (brand_id) REFERENCES brands(id) ON DELETE SET NULL",
    "table_name": "watch_models",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_models_brand_id_fkey",
    "constraint_type": "f",
    "referenced_table": "brands",
    "referenced_schema": "public"
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE",
    "table_name": "watch_models",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_models_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "watch_models",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_models_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (photo_id) REFERENCES watch_photos(id) ON DELETE CASCADE",
    "table_name": "watch_photo_links",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_photo_links_photo_id_fkey",
    "constraint_type": "f",
    "referenced_table": "watch_photos",
    "referenced_schema": "public"
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE",
    "table_name": "watch_photo_links",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_photo_links_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE CASCADE",
    "table_name": "watch_photo_links",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_photo_links_watch_id_fkey",
    "constraint_type": "f",
    "referenced_table": "watches",
    "referenced_schema": "public"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "watch_photo_links",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_photo_links_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "UNIQUE (photo_id, watch_id)",
    "table_name": "watch_photo_links",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_photo_links_photo_watch_key",
    "constraint_type": "u",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (evidence_classification IS NULL OR (evidence_classification = ANY (ARRAY['document_confirmed'::text, 'seller_statement'::text, 'visual_observation'::text, 'researched'::text, 'estimated'::text, 'missing'::text, 'inconsistent'::text])))",
    "table_name": "watch_photos",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_photos_classification_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (watch_id IS NOT NULL OR acquisition_id IS NOT NULL)",
    "table_name": "watch_photos",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_photos_owner_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (acquisition_id) REFERENCES acquisitions(id) ON DELETE CASCADE",
    "table_name": "watch_photos",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_photos_acquisition_id_fkey",
    "constraint_type": "f",
    "referenced_table": "acquisitions",
    "referenced_schema": "public"
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id)",
    "table_name": "watch_photos",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_photos_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE CASCADE",
    "table_name": "watch_photos",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_photos_watch_id_fkey",
    "constraint_type": "f",
    "referenced_table": "watches",
    "referenced_schema": "public"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "watch_photos",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_photos_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "UNIQUE (user_id, storage_path)",
    "table_name": "watch_photos",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_photos_user_id_storage_path_key",
    "constraint_type": "u",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (evidence_classification = ANY (ARRAY['document_confirmed'::text, 'seller_statement'::text, 'visual_observation'::text, 'researched'::text, 'estimated'::text, 'missing'::text, 'inconsistent'::text]))",
    "table_name": "watch_sources",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_sources_classification_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (confidence_percent IS NULL OR confidence_percent >= 0 AND confidence_percent <= 100)",
    "table_name": "watch_sources",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_sources_confidence_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (watch_id IS NOT NULL OR acquisition_id IS NOT NULL)",
    "table_name": "watch_sources",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_sources_owner_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (acquisition_id) REFERENCES acquisitions(id) ON DELETE CASCADE",
    "table_name": "watch_sources",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_sources_acquisition_id_fkey",
    "constraint_type": "f",
    "referenced_table": "acquisitions",
    "referenced_schema": "public"
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE",
    "table_name": "watch_sources",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_sources_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "FOREIGN KEY (watch_id) REFERENCES watches(id) ON DELETE CASCADE",
    "table_name": "watch_sources",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_sources_watch_id_fkey",
    "constraint_type": "f",
    "referenced_table": "watches",
    "referenced_schema": "public"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "watch_sources",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watch_sources_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK ((diameter_mm IS NULL OR diameter_mm > 0::numeric) AND (case_thickness_mm IS NULL OR case_thickness_mm > 0::numeric) AND (lug_to_lug_mm IS NULL OR lug_to_lug_mm > 0::numeric) AND (lug_width_mm IS NULL OR lug_width_mm > 0::numeric))",
    "table_name": "watches",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watches_dimensions_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (jewels IS NULL OR jewels >= 0 AND jewels <= 200)",
    "table_name": "watches",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watches_jewels_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "CHECK (production_period_start_year IS NULL OR production_period_end_year IS NULL OR production_period_start_year <= production_period_end_year)",
    "table_name": "watches",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watches_year_period_check",
    "constraint_type": "c",
    "referenced_table": null,
    "referenced_schema": null
  },
  {
    "definition": "FOREIGN KEY (brand_id) REFERENCES brands(id) ON DELETE SET NULL",
    "table_name": "watches",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watches_brand_id_fkey",
    "constraint_type": "f",
    "referenced_table": "brands",
    "referenced_schema": "public"
  },
  {
    "definition": "FOREIGN KEY (movement_caliber_id) REFERENCES movement_calibers(id) ON DELETE SET NULL",
    "table_name": "watches",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watches_movement_caliber_id_fkey",
    "constraint_type": "f",
    "referenced_table": "movement_calibers",
    "referenced_schema": "public"
  },
  {
    "definition": "FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE RESTRICT",
    "table_name": "watches",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watches_user_id_fkey",
    "constraint_type": "f",
    "referenced_table": "users",
    "referenced_schema": "auth"
  },
  {
    "definition": "FOREIGN KEY (watch_model_id) REFERENCES watch_models(id) ON DELETE SET NULL",
    "table_name": "watches",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watches_watch_model_id_fkey",
    "constraint_type": "f",
    "referenced_table": "watch_models",
    "referenced_schema": "public"
  },
  {
    "definition": "PRIMARY KEY (id)",
    "table_name": "watches",
    "condeferred": false,
    "convalidated": true,
    "condeferrable": false,
    "constraint_name": "watches_pkey",
    "constraint_type": "p",
    "referenced_table": null,
    "referenced_schema": null
  }
]
```

## 4. Índices

```json
[
  {
    "predicate": null,
    "definition": "CREATE INDEX acquisition_items_acquisition_id_idx ON acquisition_items USING btree (acquisition_id)",
    "index_name": "acquisition_items_acquisition_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisition_items",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX acquisition_items_acquisition_sequence_key ON acquisition_items USING btree (acquisition_id, item_sequence)",
    "index_name": "acquisition_items_acquisition_sequence_key",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisition_items",
    "indisunique": true,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": "acquisition_items_acquisition_sequence_key"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX acquisition_items_listing_specifics_gin_idx ON acquisition_items USING gin (listing_specifics)",
    "index_name": "acquisition_items_listing_specifics_gin_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisition_items",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX acquisition_items_pkey ON acquisition_items USING btree (id)",
    "index_name": "acquisition_items_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisition_items",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "acquisition_items_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX acquisition_items_user_id_idx ON acquisition_items USING btree (user_id)",
    "index_name": "acquisition_items_user_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisition_items",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX acquisition_items_watch_key ON acquisition_items USING btree (watch_id)",
    "index_name": "acquisition_items_watch_key",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisition_items",
    "indisunique": true,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": "acquisition_items_watch_key"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX acquisitions_pkey ON acquisitions USING btree (id)",
    "index_name": "acquisitions_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisitions",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "acquisitions_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX acquisitions_pkey ON acquisitions USING btree (id)",
    "index_name": "acquisitions_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisitions",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "acquisition_items_acquisition_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX acquisitions_pkey ON acquisitions USING btree (id)",
    "index_name": "acquisitions_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisitions",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_photos_acquisition_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX acquisitions_pkey ON acquisitions USING btree (id)",
    "index_name": "acquisitions_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisitions",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_sources_acquisition_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX acquisitions_pkey ON acquisitions USING btree (id)",
    "index_name": "acquisitions_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisitions",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "expenses_acquisition_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX acquisitions_pkey ON acquisitions USING btree (id)",
    "index_name": "acquisitions_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisitions",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_events_acquisition_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX acquisitions_user_id_idx ON acquisitions USING btree (user_id)",
    "index_name": "acquisitions_user_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisitions",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": "order_number IS NOT NULL",
    "definition": "CREATE UNIQUE INDEX acquisitions_user_order_uidx ON acquisitions USING btree (user_id, lower(COALESCE(marketplace, ''::text)), order_number) WHERE order_number IS NOT NULL",
    "index_name": "acquisitions_user_order_uidx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "acquisitions",
    "indisunique": true,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX brands_pkey ON brands USING btree (id)",
    "index_name": "brands_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "brands",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_models_brand_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX brands_pkey ON brands USING btree (id)",
    "index_name": "brands_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "brands",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "brands_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX brands_pkey ON brands USING btree (id)",
    "index_name": "brands_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "brands",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watches_brand_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX brands_user_id_name_key ON brands USING btree (user_id, name)",
    "index_name": "brands_user_id_name_key",
    "indisready": true,
    "indisvalid": true,
    "table_name": "brands",
    "indisunique": true,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": "brands_user_id_name_key"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX expense_allocations_expense_id_idx ON expense_allocations USING btree (expense_id)",
    "index_name": "expense_allocations_expense_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "expense_allocations",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX expense_allocations_expense_watch_key ON expense_allocations USING btree (expense_id, watch_id)",
    "index_name": "expense_allocations_expense_watch_key",
    "indisready": true,
    "indisvalid": true,
    "table_name": "expense_allocations",
    "indisunique": true,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": "expense_allocations_expense_watch_key"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX expense_allocations_pkey ON expense_allocations USING btree (id)",
    "index_name": "expense_allocations_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "expense_allocations",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "expense_allocations_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX expense_allocations_user_id_idx ON expense_allocations USING btree (user_id)",
    "index_name": "expense_allocations_user_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "expense_allocations",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX expense_allocations_watch_id_idx ON expense_allocations USING btree (watch_id)",
    "index_name": "expense_allocations_watch_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "expense_allocations",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX expenses_acquisition_id_idx ON expenses USING btree (acquisition_id)",
    "index_name": "expenses_acquisition_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "expenses",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX expenses_pkey ON expenses USING btree (id)",
    "index_name": "expenses_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "expenses",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "expense_allocations_expense_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX expenses_pkey ON expenses USING btree (id)",
    "index_name": "expenses_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "expenses",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "expenses_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX expenses_pkey ON expenses USING btree (id)",
    "index_name": "expenses_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "expenses",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_events_expense_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX expenses_user_id_idx ON expenses USING btree (user_id)",
    "index_name": "expenses_user_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "expenses",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX expenses_watch_id_idx ON expenses USING btree (watch_id)",
    "index_name": "expenses_watch_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "expenses",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX maintenance_logs_pkey ON maintenance_logs USING btree (id)",
    "index_name": "maintenance_logs_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "maintenance_logs",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "maintenance_logs_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX maintenance_logs_user_id_idx ON maintenance_logs USING btree (user_id)",
    "index_name": "maintenance_logs_user_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "maintenance_logs",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX maintenance_logs_watch_id_idx ON maintenance_logs USING btree (watch_id)",
    "index_name": "maintenance_logs_watch_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "maintenance_logs",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX movement_calibers_pkey ON movement_calibers USING btree (id)",
    "index_name": "movement_calibers_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "movement_calibers",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watches_movement_caliber_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX movement_calibers_pkey ON movement_calibers USING btree (id)",
    "index_name": "movement_calibers_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "movement_calibers",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "movement_calibers_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX movement_calibers_user_id_idx ON movement_calibers USING btree (user_id)",
    "index_name": "movement_calibers_user_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "movement_calibers",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX movement_calibers_user_identity_uidx ON movement_calibers USING btree (user_id, lower(COALESCE(manufacturer, ''::text)), lower(caliber_code))",
    "index_name": "movement_calibers_user_identity_uidx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "movement_calibers",
    "indisunique": true,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watch_claims_pkey ON watch_claims USING btree (id)",
    "index_name": "watch_claims_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_claims",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_claims_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_claims_review_idx ON watch_claims USING btree (watch_id, verification_status, field_name)",
    "index_name": "watch_claims_review_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_claims",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_claims_source_id_idx ON watch_claims USING btree (source_id)",
    "index_name": "watch_claims_source_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_claims",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_claims_user_id_idx ON watch_claims USING btree (user_id)",
    "index_name": "watch_claims_user_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_claims",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_claims_watch_id_idx ON watch_claims USING btree (watch_id)",
    "index_name": "watch_claims_watch_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_claims",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_events_acquisition_id_idx ON watch_events USING btree (acquisition_id)",
    "index_name": "watch_events_acquisition_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_events",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_events_expense_id_idx ON watch_events USING btree (expense_id)",
    "index_name": "watch_events_expense_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_events",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watch_events_pkey ON watch_events USING btree (id)",
    "index_name": "watch_events_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_events",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_events_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_events_user_id_idx ON watch_events USING btree (user_id)",
    "index_name": "watch_events_user_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_events",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_events_watch_date_idx ON watch_events USING btree (watch_id, event_date DESC)",
    "index_name": "watch_events_watch_date_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_events",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_models_brand_id_idx ON watch_models USING btree (brand_id)",
    "index_name": "watch_models_brand_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_models",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watch_models_pkey ON watch_models USING btree (id)",
    "index_name": "watch_models_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_models",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_models_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watch_models_pkey ON watch_models USING btree (id)",
    "index_name": "watch_models_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_models",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watches_watch_model_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_models_user_id_idx ON watch_models USING btree (user_id)",
    "index_name": "watch_models_user_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_models",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watch_models_user_identity_uidx ON watch_models USING btree (user_id, COALESCE(brand_id, 0::bigint), lower(model_name), lower(COALESCE(line_name, ''::text)), lower(COALESCE(reference_family, ''::text)))",
    "index_name": "watch_models_user_identity_uidx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_models",
    "indisunique": true,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_photo_links_photo_id_idx ON watch_photo_links USING btree (photo_id)",
    "index_name": "watch_photo_links_photo_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_photo_links",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watch_photo_links_photo_watch_key ON watch_photo_links USING btree (photo_id, watch_id)",
    "index_name": "watch_photo_links_photo_watch_key",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_photo_links",
    "indisunique": true,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": "watch_photo_links_photo_watch_key"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watch_photo_links_pkey ON watch_photo_links USING btree (id)",
    "index_name": "watch_photo_links_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_photo_links",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_photo_links_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_photo_links_user_id_idx ON watch_photo_links USING btree (user_id)",
    "index_name": "watch_photo_links_user_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_photo_links",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_photo_links_watch_id_idx ON watch_photo_links USING btree (watch_id)",
    "index_name": "watch_photo_links_watch_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_photo_links",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_photos_acquisition_id_idx ON watch_photos USING btree (acquisition_id)",
    "index_name": "watch_photos_acquisition_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_photos",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watch_photos_pkey ON watch_photos USING btree (id)",
    "index_name": "watch_photos_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_photos",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_photo_links_photo_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watch_photos_pkey ON watch_photos USING btree (id)",
    "index_name": "watch_photos_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_photos",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_photos_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watch_photos_user_id_storage_path_key ON watch_photos USING btree (user_id, storage_path)",
    "index_name": "watch_photos_user_id_storage_path_key",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_photos",
    "indisunique": true,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": "watch_photos_user_id_storage_path_key"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_photos_watch_id_idx ON watch_photos USING btree (watch_id)",
    "index_name": "watch_photos_watch_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_photos",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_sources_acquisition_id_idx ON watch_sources USING btree (acquisition_id)",
    "index_name": "watch_sources_acquisition_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_sources",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watch_sources_pkey ON watch_sources USING btree (id)",
    "index_name": "watch_sources_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_sources",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_sources_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watch_sources_pkey ON watch_sources USING btree (id)",
    "index_name": "watch_sources_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_sources",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_claims_source_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_sources_user_id_idx ON watch_sources USING btree (user_id)",
    "index_name": "watch_sources_user_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_sources",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watch_sources_watch_id_idx ON watch_sources USING btree (watch_id)",
    "index_name": "watch_sources_watch_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watch_sources",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watches_brand_id_idx ON watches USING btree (brand_id)",
    "index_name": "watches_brand_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watches_movement_caliber_id_idx ON watches USING btree (movement_caliber_id)",
    "index_name": "watches_movement_caliber_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watches_pkey ON watches USING btree (id)",
    "index_name": "watches_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_photo_links_watch_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watches_pkey ON watches USING btree (id)",
    "index_name": "watches_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "acquisition_items_watch_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watches_pkey ON watches USING btree (id)",
    "index_name": "watches_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "expenses_watch_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watches_pkey ON watches USING btree (id)",
    "index_name": "watches_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watches_pkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watches_pkey ON watches USING btree (id)",
    "index_name": "watches_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "expense_allocations_watch_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watches_pkey ON watches USING btree (id)",
    "index_name": "watches_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_sources_watch_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watches_pkey ON watches USING btree (id)",
    "index_name": "watches_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_claims_watch_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watches_pkey ON watches USING btree (id)",
    "index_name": "watches_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_events_watch_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watches_pkey ON watches USING btree (id)",
    "index_name": "watches_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "watch_photos_watch_id_fkey"
  },
  {
    "predicate": null,
    "definition": "CREATE UNIQUE INDEX watches_pkey ON watches USING btree (id)",
    "index_name": "watches_pkey",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": true,
    "indisprimary": true,
    "indisclustered": false,
    "backing_constraint": "maintenance_logs_watch_id_fkey"
  },
  {
    "predicate": "horoteca_code IS NOT NULL",
    "definition": "CREATE UNIQUE INDEX watches_user_horoteca_code_uidx ON watches USING btree (user_id, horoteca_code) WHERE horoteca_code IS NOT NULL",
    "index_name": "watches_user_horoteca_code_uidx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": true,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watches_user_id_idx ON watches USING btree (user_id)",
    "index_name": "watches_user_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": "order_number IS NOT NULL AND order_item_number IS NOT NULL",
    "definition": "CREATE UNIQUE INDEX watches_user_order_item_uidx ON watches USING btree (user_id, lower(COALESCE(marketplace, ''::text)), order_number, order_item_number) WHERE order_number IS NOT NULL AND order_item_number IS NOT NULL",
    "index_name": "watches_user_order_item_uidx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": true,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  },
  {
    "predicate": null,
    "definition": "CREATE INDEX watches_watch_model_id_idx ON watches USING btree (watch_model_id)",
    "index_name": "watches_watch_model_id_idx",
    "indisready": true,
    "indisvalid": true,
    "table_name": "watches",
    "indisunique": false,
    "indisprimary": false,
    "indisclustered": false,
    "backing_constraint": null
  }
]
```

## 5. Funções e triggers

```json
{
  "functions": [
    {
      "proconfig": [
        "search_path=\"\""
      ],
      "definition": "CREATE OR REPLACE FUNCTION public.set_updated_at()\n RETURNS trigger\n LANGUAGE plpgsql\n SET search_path TO ''\nAS $function$\nbegin\n  new.updated_at = now();\n  return new;\nend;\n$function$\n",
      "owner_name": "postgres",
      "provolatile": "v",
      "proleakproof": false,
      "function_name": "set_updated_at",
      "security_definer": false,
      "identity_arguments": ""
    }
  ],
  "triggers": [
    {
      "tgenabled": "O",
      "definition": "CREATE TRIGGER acquisition_items_set_updated_at BEFORE UPDATE ON acquisition_items FOR EACH ROW EXECUTE FUNCTION set_updated_at()",
      "table_name": "acquisition_items",
      "trigger_name": "acquisition_items_set_updated_at"
    },
    {
      "tgenabled": "O",
      "definition": "CREATE TRIGGER acquisitions_set_updated_at BEFORE UPDATE ON acquisitions FOR EACH ROW EXECUTE FUNCTION set_updated_at()",
      "table_name": "acquisitions",
      "trigger_name": "acquisitions_set_updated_at"
    },
    {
      "tgenabled": "O",
      "definition": "CREATE TRIGGER expenses_set_updated_at BEFORE UPDATE ON expenses FOR EACH ROW EXECUTE FUNCTION set_updated_at()",
      "table_name": "expenses",
      "trigger_name": "expenses_set_updated_at"
    },
    {
      "tgenabled": "O",
      "definition": "CREATE TRIGGER maintenance_logs_set_updated_at BEFORE UPDATE ON maintenance_logs FOR EACH ROW EXECUTE FUNCTION set_updated_at()",
      "table_name": "maintenance_logs",
      "trigger_name": "maintenance_logs_set_updated_at"
    },
    {
      "tgenabled": "O",
      "definition": "CREATE TRIGGER movement_calibers_set_updated_at BEFORE UPDATE ON movement_calibers FOR EACH ROW EXECUTE FUNCTION set_updated_at()",
      "table_name": "movement_calibers",
      "trigger_name": "movement_calibers_set_updated_at"
    },
    {
      "tgenabled": "O",
      "definition": "CREATE TRIGGER watch_claims_set_updated_at BEFORE UPDATE ON watch_claims FOR EACH ROW EXECUTE FUNCTION set_updated_at()",
      "table_name": "watch_claims",
      "trigger_name": "watch_claims_set_updated_at"
    },
    {
      "tgenabled": "O",
      "definition": "CREATE TRIGGER watch_events_set_updated_at BEFORE UPDATE ON watch_events FOR EACH ROW EXECUTE FUNCTION set_updated_at()",
      "table_name": "watch_events",
      "trigger_name": "watch_events_set_updated_at"
    },
    {
      "tgenabled": "O",
      "definition": "CREATE TRIGGER watch_models_set_updated_at BEFORE UPDATE ON watch_models FOR EACH ROW EXECUTE FUNCTION set_updated_at()",
      "table_name": "watch_models",
      "trigger_name": "watch_models_set_updated_at"
    },
    {
      "tgenabled": "O",
      "definition": "CREATE TRIGGER watches_set_updated_at BEFORE UPDATE ON watches FOR EACH ROW EXECUTE FUNCTION set_updated_at()",
      "table_name": "watches",
      "trigger_name": "watches_set_updated_at"
    }
  ]
}
```

## 6. RLS e políticas

```json
[
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "acquisition_items",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "acquisition_items",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND (EXISTS ( SELECT 1\n   FROM acquisitions acquisition\n  WHERE ((acquisition.id = acquisition_items.acquisition_id) AND (acquisition.user_id = ( SELECT auth.uid() AS uid))))) AND (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = acquisition_items.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid))))))"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "acquisition_items",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "acquisition_items",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND (EXISTS ( SELECT 1\n   FROM acquisitions acquisition\n  WHERE ((acquisition.id = acquisition_items.acquisition_id) AND (acquisition.user_id = ( SELECT auth.uid() AS uid))))) AND (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = acquisition_items.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid))))))"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "acquisitions",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "acquisitions",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert",
    "schemaname": "public",
    "with_check": "(( SELECT auth.uid() AS uid) = user_id)"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "acquisitions",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "acquisitions",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update",
    "schemaname": "public",
    "with_check": "(( SELECT auth.uid() AS uid) = user_id)"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "brands",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete_brands",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "brands",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert_brands",
    "schemaname": "public",
    "with_check": "(( SELECT auth.uid() AS uid) = user_id)"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "brands",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select_brands",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "brands",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update_brands",
    "schemaname": "public",
    "with_check": "(( SELECT auth.uid() AS uid) = user_id)"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "expense_allocations",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "expense_allocations",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND (EXISTS ( SELECT 1\n   FROM expenses expense\n  WHERE ((expense.id = expense_allocations.expense_id) AND (expense.user_id = ( SELECT auth.uid() AS uid))))) AND (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = expense_allocations.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid))))))"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "expense_allocations",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "expense_allocations",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND (EXISTS ( SELECT 1\n   FROM expenses expense\n  WHERE ((expense.id = expense_allocations.expense_id) AND (expense.user_id = ( SELECT auth.uid() AS uid))))) AND (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = expense_allocations.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid))))))"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "expenses",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "expenses",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND ((watch_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = expenses.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid)))))) AND ((acquisition_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM acquisitions acquisition\n  WHERE ((acquisition.id = expenses.acquisition_id) AND (acquisition.user_id = ( SELECT auth.uid() AS uid)))))))"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "expenses",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "expenses",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND ((watch_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = expenses.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid)))))) AND ((acquisition_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM acquisitions acquisition\n  WHERE ((acquisition.id = expenses.acquisition_id) AND (acquisition.user_id = ( SELECT auth.uid() AS uid)))))))"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "maintenance_logs",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete_maintenance_logs",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "maintenance_logs",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert_maintenance_logs",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND (EXISTS ( SELECT 1\n   FROM watches w\n  WHERE ((w.id = maintenance_logs.watch_id) AND (w.user_id = ( SELECT auth.uid() AS uid))))))"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "maintenance_logs",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select_maintenance_logs",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "maintenance_logs",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update_maintenance_logs",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND (EXISTS ( SELECT 1\n   FROM watches w\n  WHERE ((w.id = maintenance_logs.watch_id) AND (w.user_id = ( SELECT auth.uid() AS uid))))))"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "movement_calibers",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "movement_calibers",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert",
    "schemaname": "public",
    "with_check": "(( SELECT auth.uid() AS uid) = user_id)"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "movement_calibers",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "movement_calibers",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update",
    "schemaname": "public",
    "with_check": "(( SELECT auth.uid() AS uid) = user_id)"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_claims",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_claims",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = watch_claims.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid))))) AND ((source_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM watch_sources source\n  WHERE ((source.id = watch_claims.source_id) AND (source.user_id = ( SELECT auth.uid() AS uid)))))))"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_claims",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_claims",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = watch_claims.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid))))) AND ((source_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM watch_sources source\n  WHERE ((source.id = watch_claims.source_id) AND (source.user_id = ( SELECT auth.uid() AS uid)))))))"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_events",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_events",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND ((watch_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = watch_events.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid)))))) AND ((acquisition_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM acquisitions acquisition\n  WHERE ((acquisition.id = watch_events.acquisition_id) AND (acquisition.user_id = ( SELECT auth.uid() AS uid)))))) AND ((expense_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM expenses expense\n  WHERE ((expense.id = watch_events.expense_id) AND (expense.user_id = ( SELECT auth.uid() AS uid)))))))"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_events",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_events",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND ((watch_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = watch_events.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid)))))) AND ((acquisition_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM acquisitions acquisition\n  WHERE ((acquisition.id = watch_events.acquisition_id) AND (acquisition.user_id = ( SELECT auth.uid() AS uid)))))) AND ((expense_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM expenses expense\n  WHERE ((expense.id = watch_events.expense_id) AND (expense.user_id = ( SELECT auth.uid() AS uid)))))))"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_models",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_models",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert",
    "schemaname": "public",
    "with_check": "(( SELECT auth.uid() AS uid) = user_id)"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_models",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_models",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update",
    "schemaname": "public",
    "with_check": "(( SELECT auth.uid() AS uid) = user_id)"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_photo_links",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_photo_links",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND (EXISTS ( SELECT 1\n   FROM watch_photos photo\n  WHERE ((photo.id = watch_photo_links.photo_id) AND (photo.user_id = ( SELECT auth.uid() AS uid))))) AND (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = watch_photo_links.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid))))))"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_photo_links",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_photo_links",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND (EXISTS ( SELECT 1\n   FROM watch_photos photo\n  WHERE ((photo.id = watch_photo_links.photo_id) AND (photo.user_id = ( SELECT auth.uid() AS uid))))) AND (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = watch_photo_links.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid))))))"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_photos",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete_watch_photos",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_photos",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert_watch_photos",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND (((watch_id IS NOT NULL) AND (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = watch_photos.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid)))))) OR ((acquisition_id IS NOT NULL) AND (EXISTS ( SELECT 1\n   FROM acquisitions acquisition\n  WHERE ((acquisition.id = watch_photos.acquisition_id) AND (acquisition.user_id = ( SELECT auth.uid() AS uid))))))))"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_photos",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select_watch_photos",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_photos",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update_watch_photos",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND (((watch_id IS NOT NULL) AND (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = watch_photos.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid)))))) OR ((acquisition_id IS NOT NULL) AND (EXISTS ( SELECT 1\n   FROM acquisitions acquisition\n  WHERE ((acquisition.id = watch_photos.acquisition_id) AND (acquisition.user_id = ( SELECT auth.uid() AS uid))))))))"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_sources",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_sources",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND ((watch_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = watch_sources.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid)))))) AND ((acquisition_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM acquisitions acquisition\n  WHERE ((acquisition.id = watch_sources.acquisition_id) AND (acquisition.user_id = ( SELECT auth.uid() AS uid)))))))"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_sources",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watch_sources",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update",
    "schemaname": "public",
    "with_check": "((( SELECT auth.uid() AS uid) = user_id) AND ((watch_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM watches watch\n  WHERE ((watch.id = watch_sources.watch_id) AND (watch.user_id = ( SELECT auth.uid() AS uid)))))) AND ((acquisition_id IS NULL) OR (EXISTS ( SELECT 1\n   FROM acquisitions acquisition\n  WHERE ((acquisition.id = watch_sources.acquisition_id) AND (acquisition.user_id = ( SELECT auth.uid() AS uid)))))))"
  },
  {
    "cmd": "DELETE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watches",
    "permissive": "PERMISSIVE",
    "policyname": "owners_delete_watches",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "watches",
    "permissive": "PERMISSIVE",
    "policyname": "owners_insert_watches",
    "schemaname": "public",
    "with_check": "(( SELECT auth.uid() AS uid) = user_id)"
  },
  {
    "cmd": "SELECT",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watches",
    "permissive": "PERMISSIVE",
    "policyname": "owners_select_watches",
    "schemaname": "public",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "(( SELECT auth.uid() AS uid) = user_id)",
    "roles": [
      "authenticated"
    ],
    "tablename": "watches",
    "permissive": "PERMISSIVE",
    "policyname": "owners_update_watches",
    "schemaname": "public",
    "with_check": "(( SELECT auth.uid() AS uid) = user_id)"
  },
  {
    "cmd": "DELETE",
    "qual": "((bucket_id = 'watch-photos'::text) AND ((storage.foldername(name))[1] = (( SELECT auth.uid() AS uid))::text))",
    "roles": [
      "authenticated"
    ],
    "tablename": "objects",
    "permissive": "PERMISSIVE",
    "policyname": "owner_delete_watch_photo_objects",
    "schemaname": "storage",
    "with_check": null
  },
  {
    "cmd": "INSERT",
    "qual": null,
    "roles": [
      "authenticated"
    ],
    "tablename": "objects",
    "permissive": "PERMISSIVE",
    "policyname": "owner_insert_watch_photo_objects",
    "schemaname": "storage",
    "with_check": "((bucket_id = 'watch-photos'::text) AND ((storage.foldername(name))[1] = (( SELECT auth.uid() AS uid))::text))"
  },
  {
    "cmd": "SELECT",
    "qual": "((bucket_id = 'watch-photos'::text) AND ((storage.foldername(name))[1] = (( SELECT auth.uid() AS uid))::text))",
    "roles": [
      "authenticated"
    ],
    "tablename": "objects",
    "permissive": "PERMISSIVE",
    "policyname": "owner_select_watch_photo_objects",
    "schemaname": "storage",
    "with_check": null
  },
  {
    "cmd": "UPDATE",
    "qual": "((bucket_id = 'watch-photos'::text) AND ((storage.foldername(name))[1] = (( SELECT auth.uid() AS uid))::text))",
    "roles": [
      "authenticated"
    ],
    "tablename": "objects",
    "permissive": "PERMISSIVE",
    "policyname": "owner_update_watch_photo_objects",
    "schemaname": "storage",
    "with_check": "((bucket_id = 'watch-photos'::text) AND ((storage.foldername(name))[1] = (( SELECT auth.uid() AS uid))::text))"
  }
]
```

## 7. Grants

```json
{
  "table_grants": [
    {
      "grantee": "authenticated",
      "table_name": "acquisition_items",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "acquisition_items",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "acquisition_items",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "acquisition_items",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisition_items",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisition_items",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisition_items",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisition_items",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisition_items",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisition_items",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisition_items",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisition_items",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisition_items",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisition_items",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisition_items",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisition_items",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisition_items",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisition_items",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "acquisitions",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "acquisitions",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "acquisitions",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "acquisitions",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisitions",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisitions",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisitions",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisitions",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisitions",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisitions",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "acquisitions",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisitions",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisitions",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisitions",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisitions",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisitions",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisitions",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "acquisitions",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "brands",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "brands",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "brands",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "brands",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "brands",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "brands",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "brands",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "brands",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "brands",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "brands",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "brands",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "brands",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "brands",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "brands",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "brands",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "brands",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "brands",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "brands",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "expense_allocations",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "expense_allocations",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "expense_allocations",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "expense_allocations",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "expense_allocations",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "expense_allocations",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "expense_allocations",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "expense_allocations",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "expense_allocations",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "expense_allocations",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "expense_allocations",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "expense_allocations",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "expense_allocations",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "expense_allocations",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "expense_allocations",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "expense_allocations",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "expense_allocations",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "expense_allocations",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "expenses",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "expenses",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "expenses",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "expenses",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "expenses",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "expenses",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "expenses",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "expenses",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "expenses",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "expenses",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "expenses",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "expenses",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "expenses",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "expenses",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "expenses",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "expenses",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "expenses",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "expenses",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "maintenance_logs",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "maintenance_logs",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "maintenance_logs",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "maintenance_logs",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "maintenance_logs",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "maintenance_logs",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "maintenance_logs",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "maintenance_logs",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "maintenance_logs",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "maintenance_logs",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "maintenance_logs",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "maintenance_logs",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "maintenance_logs",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "maintenance_logs",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "maintenance_logs",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "maintenance_logs",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "maintenance_logs",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "maintenance_logs",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "movement_calibers",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "movement_calibers",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "movement_calibers",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "movement_calibers",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "movement_calibers",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "movement_calibers",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "movement_calibers",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "movement_calibers",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "movement_calibers",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "movement_calibers",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "movement_calibers",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "movement_calibers",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "movement_calibers",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "movement_calibers",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "movement_calibers",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "movement_calibers",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "movement_calibers",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "movement_calibers",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_claims",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_claims",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_claims",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_claims",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_claims",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_claims",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_claims",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_claims",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_claims",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_claims",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_claims",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_claims",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_claims",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_claims",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_claims",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_claims",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_claims",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_claims",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_events",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_events",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_events",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_events",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_events",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_events",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_events",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_events",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_events",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_events",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_events",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_events",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_events",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_events",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_events",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_events",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_events",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_events",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_models",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_models",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_models",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_models",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_models",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_models",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_models",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_models",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_models",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_models",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_models",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_models",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_models",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_models",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_models",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_models",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_models",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_models",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_photo_links",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_photo_links",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_photo_links",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_photo_links",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photo_links",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photo_links",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photo_links",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photo_links",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photo_links",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photo_links",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photo_links",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photo_links",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photo_links",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photo_links",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photo_links",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photo_links",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photo_links",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photo_links",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_photos",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_photos",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_photos",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_photos",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photos",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photos",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photos",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photos",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photos",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photos",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_photos",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photos",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photos",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photos",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photos",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photos",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photos",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_photos",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_sources",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_sources",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_sources",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watch_sources",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_sources",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_sources",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_sources",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_sources",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_sources",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_sources",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watch_sources",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_sources",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_sources",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_sources",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_sources",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_sources",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_sources",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watch_sources",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watches",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "authenticated",
      "table_name": "watches",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watches",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "authenticated",
      "table_name": "watches",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watches",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "postgres",
      "table_name": "watches",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "postgres",
      "table_name": "watches",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "postgres",
      "table_name": "watches",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "postgres",
      "table_name": "watches",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "postgres",
      "table_name": "watches",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "postgres",
      "table_name": "watches",
      "is_grantable": "YES",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watches",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "DELETE"
    },
    {
      "grantee": "service_role",
      "table_name": "watches",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "INSERT"
    },
    {
      "grantee": "service_role",
      "table_name": "watches",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "REFERENCES"
    },
    {
      "grantee": "service_role",
      "table_name": "watches",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "SELECT"
    },
    {
      "grantee": "service_role",
      "table_name": "watches",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRIGGER"
    },
    {
      "grantee": "service_role",
      "table_name": "watches",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "TRUNCATE"
    },
    {
      "grantee": "service_role",
      "table_name": "watches",
      "is_grantable": "NO",
      "table_schema": "public",
      "privilege_type": "UPDATE"
    }
  ],
  "routine_grants": [
    {
      "grantee": "postgres",
      "is_grantable": "YES",
      "routine_name": "set_updated_at",
      "specific_name": "set_updated_at_33942",
      "privilege_type": "EXECUTE"
    },
    {
      "grantee": "service_role",
      "is_grantable": "NO",
      "routine_name": "set_updated_at",
      "specific_name": "set_updated_at_33942",
      "privilege_type": "EXECUTE"
    }
  ],
  "sequence_grants": [
    {
      "grantee": "authenticated",
      "object_name": "acquisition_items_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "acquisition_items_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "acquisition_items_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "acquisitions_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "acquisitions_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "acquisitions_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "brands_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "brands_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "brands_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "expense_allocations_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "expense_allocations_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "expense_allocations_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "expenses_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "expenses_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "expenses_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "maintenance_logs_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "maintenance_logs_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "maintenance_logs_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "movement_calibers_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "movement_calibers_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "movement_calibers_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "watch_claims_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "watch_claims_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "watch_claims_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "watch_events_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "watch_events_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "watch_events_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "watch_models_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "watch_models_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "watch_models_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "watch_photo_links_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "watch_photo_links_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "watch_photo_links_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "watch_photos_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "watch_photos_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "watch_photos_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "watch_sources_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "watch_sources_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "watch_sources_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "authenticated",
      "object_name": "watches_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "postgres",
      "object_name": "watches_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "YES",
      "privilege_type": "USAGE"
    },
    {
      "grantee": "service_role",
      "object_name": "watches_id_seq",
      "object_type": "SEQUENCE",
      "is_grantable": "NO",
      "privilege_type": "USAGE"
    }
  ]
}
```

## 8. Views e extensões

```json
{
  "views": null,
  "extensions": [
    {
      "schema_name": "extensions",
      "extension_name": "pg_stat_statements",
      "extrelocatable": true,
      "extension_version": "1.11"
    },
    {
      "schema_name": "extensions",
      "extension_name": "pgcrypto",
      "extrelocatable": true,
      "extension_version": "1.3"
    },
    {
      "schema_name": "pg_catalog",
      "extension_name": "plpgsql",
      "extrelocatable": false,
      "extension_version": "1.0"
    },
    {
      "schema_name": "vault",
      "extension_name": "supabase_vault",
      "extrelocatable": false,
      "extension_version": "0.3.1"
    },
    {
      "schema_name": "extensions",
      "extension_name": "uuid-ossp",
      "extrelocatable": true,
      "extension_version": "1.1"
    }
  ]
}
```

## 9. Bucket watch-photos

```json
{
  "id": "watch-photos",
  "name": "watch-photos",
  "type": "STANDARD",
  "owner": null,
  "public": false,
  "owner_id": null,
  "created_at": "2026-08-06T03:57:00.217824+00:00",
  "updated_at": "2026-08-06T03:57:00.217824+00:00",
  "file_size_limit": 15728640,
  "versioning_status": "DISABLED",
  "allowed_mime_types": [
    "image/jpeg",
    "image/png",
    "image/webp",
    "image/heic",
    "image/heif"
  ],
  "avif_autodetection": false
}
```

## Regras para uso

1. Comparar este snapshot com as migrations existentes.
2. Criar uma baseline de reconstrução em arquivos novos, sem alterar migrations já aplicadas.
3. Preservar tipos, defaults, identidades, nulabilidade, constraints, índices, triggers, RLS, políticas e grants.
4. Não incluir dados operacionais nem valores de sequence/contadores.
5. Não executar a baseline na produção durante sua criação.
6. Testar a reconstrução apenas em ambiente descartável antes de qualquer aplicação.

