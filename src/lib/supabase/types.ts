export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.18"
  }
  public: {
    Tables: {
      agents: {
        Row: {
          cc_emails: string[]
          company: string
          contact_name: string | null
          created_at: string
          email: string
          email_rules: string | null
          id: string
          is_internal: boolean
          notes: string | null
          ports: string[]
          wechat: string | null
        }
        Insert: {
          cc_emails?: string[]
          company: string
          contact_name?: string | null
          created_at?: string
          email: string
          email_rules?: string | null
          id?: string
          is_internal?: boolean
          notes?: string | null
          ports?: string[]
          wechat?: string | null
        }
        Update: {
          cc_emails?: string[]
          company?: string
          contact_name?: string | null
          created_at?: string
          email?: string
          email_rules?: string | null
          id?: string
          is_internal?: boolean
          notes?: string | null
          ports?: string[]
          wechat?: string | null
        }
        Relationships: []
      }
      clients: {
        Row: {
          contact_name: string | null
          created_at: string
          email: string | null
          id: string
          name: string
          notes: string | null
          whatsapp: string | null
        }
        Insert: {
          contact_name?: string | null
          created_at?: string
          email?: string | null
          id?: string
          name: string
          notes?: string | null
          whatsapp?: string | null
        }
        Update: {
          contact_name?: string | null
          created_at?: string
          email?: string | null
          id?: string
          name?: string
          notes?: string | null
          whatsapp?: string | null
        }
        Relationships: []
      }
      documents: {
        Row: {
          created_at: string
          extracted: Json | null
          file_name: string
          graph_attachment_id: string | null
          graph_message_id: string | null
          id: string
          kind: string
          received_at: string | null
          shipment_id: string
          source: string
          storage_path: string | null
          version: number
        }
        Insert: {
          created_at?: string
          extracted?: Json | null
          file_name: string
          graph_attachment_id?: string | null
          graph_message_id?: string | null
          id?: string
          kind: string
          received_at?: string | null
          shipment_id: string
          source: string
          storage_path?: string | null
          version?: number
        }
        Update: {
          created_at?: string
          extracted?: Json | null
          file_name?: string
          graph_attachment_id?: string | null
          graph_message_id?: string | null
          id?: string
          kind?: string
          received_at?: string | null
          shipment_id?: string
          source?: string
          storage_path?: string | null
          version?: number
        }
        Relationships: [
          {
            foreignKeyName: "documents_shipment_id_fkey"
            columns: ["shipment_id"]
            isOneToOne: false
            referencedRelation: "shipments"
            referencedColumns: ["id"]
          },
        ]
      }
      drafts: {
        Row: {
          body: string
          cc_emails: string[]
          channel: string
          created_at: string
          created_by: string
          draft_type: string
          error: string | null
          id: string
          linked_id: string
          linked_type: string
          reason: string | null
          reply_to_graph_message_id: string | null
          sent_at: string | null
          status: string
          subject: string | null
          to_emails: string[]
        }
        Insert: {
          body?: string
          cc_emails?: string[]
          channel: string
          created_at?: string
          created_by?: string
          draft_type: string
          error?: string | null
          id?: string
          linked_id: string
          linked_type: string
          reason?: string | null
          reply_to_graph_message_id?: string | null
          sent_at?: string | null
          status?: string
          subject?: string | null
          to_emails?: string[]
        }
        Update: {
          body?: string
          cc_emails?: string[]
          channel?: string
          created_at?: string
          created_by?: string
          draft_type?: string
          error?: string | null
          id?: string
          linked_id?: string
          linked_type?: string
          reason?: string | null
          reply_to_graph_message_id?: string | null
          sent_at?: string | null
          status?: string
          subject?: string | null
          to_emails?: string[]
        }
        Relationships: []
      }
      email_messages: {
        Row: {
          body_html: string | null
          body_preview: string | null
          cc_emails: string[]
          conversation_id: string | null
          created_at: string
          direction: string
          from_email: string | null
          graph_message_id: string
          has_attachments: boolean
          id: string
          linked_id: string | null
          linked_type: string | null
          match_method: string | null
          received_at: string | null
          subject: string | null
          to_emails: string[]
        }
        Insert: {
          body_html?: string | null
          body_preview?: string | null
          cc_emails?: string[]
          conversation_id?: string | null
          created_at?: string
          direction: string
          from_email?: string | null
          graph_message_id: string
          has_attachments?: boolean
          id?: string
          linked_id?: string | null
          linked_type?: string | null
          match_method?: string | null
          received_at?: string | null
          subject?: string | null
          to_emails?: string[]
        }
        Update: {
          body_html?: string | null
          body_preview?: string | null
          cc_emails?: string[]
          conversation_id?: string | null
          created_at?: string
          direction?: string
          from_email?: string | null
          graph_message_id?: string
          has_attachments?: boolean
          id?: string
          linked_id?: string | null
          linked_type?: string | null
          match_method?: string | null
          received_at?: string | null
          subject?: string | null
          to_emails?: string[]
        }
        Relationships: []
      }
      inquiries: {
        Row: {
          client_id: string
          commodity: string | null
          container_qty: number | null
          container_type: string | null
          created_at: string
          id: string
          incoterm: string | null
          margin_usd: number | null
          pod: string | null
          pol: string | null
          raw_message: string | null
          ready_date: string | null
          ref: string
          selected_rate_id: string | null
          status: string
          weight_kg: number | null
        }
        Insert: {
          client_id: string
          commodity?: string | null
          container_qty?: number | null
          container_type?: string | null
          created_at?: string
          id?: string
          incoterm?: string | null
          margin_usd?: number | null
          pod?: string | null
          pol?: string | null
          raw_message?: string | null
          ready_date?: string | null
          ref: string
          selected_rate_id?: string | null
          status?: string
          weight_kg?: number | null
        }
        Update: {
          client_id?: string
          commodity?: string | null
          container_qty?: number | null
          container_type?: string | null
          created_at?: string
          id?: string
          incoterm?: string | null
          margin_usd?: number | null
          pod?: string | null
          pol?: string | null
          raw_message?: string | null
          ready_date?: string | null
          ref?: string
          selected_rate_id?: string | null
          status?: string
          weight_kg?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "inquiries_client_id_fkey"
            columns: ["client_id"]
            isOneToOne: false
            referencedRelation: "clients"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "inquiries_selected_rate_id_fkey"
            columns: ["selected_rate_id"]
            isOneToOne: false
            referencedRelation: "inquiry_rates"
            referencedColumns: ["id"]
          },
        ]
      }
      inquiry_rates: {
        Row: {
          agent_id: string
          created_at: string
          free_days: number | null
          freight_usd: number | null
          id: string
          inquiry_id: string
          local_charges_usd: number | null
          notes: string | null
          received_at: string | null
          requested_at: string | null
          source_email_id: string | null
          status: string
          transit_days: number | null
          valid_until: string | null
        }
        Insert: {
          agent_id: string
          created_at?: string
          free_days?: number | null
          freight_usd?: number | null
          id?: string
          inquiry_id: string
          local_charges_usd?: number | null
          notes?: string | null
          received_at?: string | null
          requested_at?: string | null
          source_email_id?: string | null
          status?: string
          transit_days?: number | null
          valid_until?: string | null
        }
        Update: {
          agent_id?: string
          created_at?: string
          free_days?: number | null
          freight_usd?: number | null
          id?: string
          inquiry_id?: string
          local_charges_usd?: number | null
          notes?: string | null
          received_at?: string | null
          requested_at?: string | null
          source_email_id?: string | null
          status?: string
          transit_days?: number | null
          valid_until?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "inquiry_rates_agent_id_fkey"
            columns: ["agent_id"]
            isOneToOne: false
            referencedRelation: "agents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "inquiry_rates_inquiry_id_fkey"
            columns: ["inquiry_id"]
            isOneToOne: false
            referencedRelation: "inquiries"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "inquiry_rates_source_email_id_fkey"
            columns: ["source_email_id"]
            isOneToOne: false
            referencedRelation: "email_messages"
            referencedColumns: ["id"]
          },
        ]
      }
      ms_connection: {
        Row: {
          account_email: string
          created_at: string
          delta_link: string | null
          encrypted_refresh_token: string
          id: string
          singleton: boolean
          token_expires_at: string | null
        }
        Insert: {
          account_email: string
          created_at?: string
          delta_link?: string | null
          encrypted_refresh_token: string
          id?: string
          singleton?: boolean
          token_expires_at?: string | null
        }
        Update: {
          account_email?: string
          created_at?: string
          delta_link?: string | null
          encrypted_refresh_token?: string
          id?: string
          singleton?: boolean
          token_expires_at?: string | null
        }
        Relationships: []
      }
      settings: {
        Row: {
          created_at: string
          default_margin_usd: number | null
          followup_after_days: number
          id: string
          ops_email: string | null
          release_request_days_before_eta: number
          signature: string | null
          singleton: boolean
        }
        Insert: {
          created_at?: string
          default_margin_usd?: number | null
          followup_after_days?: number
          id?: string
          ops_email?: string | null
          release_request_days_before_eta?: number
          signature?: string | null
          singleton?: boolean
        }
        Update: {
          created_at?: string
          default_margin_usd?: number | null
          followup_after_days?: number
          id?: string
          ops_email?: string | null
          release_request_days_before_eta?: number
          signature?: string | null
          singleton?: boolean
        }
        Relationships: []
      }
      shipment_events: {
        Row: {
          actor: string
          channel: string
          created_at: string
          detail: string | null
          email_id: string | null
          id: string
          occurred_at: string
          shipment_id: string
          title: string
        }
        Insert: {
          actor: string
          channel: string
          created_at?: string
          detail?: string | null
          email_id?: string | null
          id?: string
          occurred_at?: string
          shipment_id: string
          title: string
        }
        Update: {
          actor?: string
          channel?: string
          created_at?: string
          detail?: string | null
          email_id?: string | null
          id?: string
          occurred_at?: string
          shipment_id?: string
          title?: string
        }
        Relationships: [
          {
            foreignKeyName: "shipment_events_email_id_fkey"
            columns: ["email_id"]
            isOneToOne: false
            referencedRelation: "email_messages"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "shipment_events_shipment_id_fkey"
            columns: ["shipment_id"]
            isOneToOne: false
            referencedRelation: "shipments"
            referencedColumns: ["id"]
          },
        ]
      }
      shipments: {
        Row: {
          agent_id: string | null
          booking_no: string | null
          client_id: string
          closed_at: string | null
          container_no: string | null
          container_qty: number | null
          container_type: string | null
          created_at: string
          eta: string | null
          etd: string | null
          id: string
          inquiry_id: string | null
          pod: string | null
          pol: string | null
          ref: string
          release_type: string | null
          seal_no: string | null
          shipping_line: string | null
          stage: string
          stuffing_date: string | null
          supplier_id: string | null
          vessel: string | null
          voyage: string | null
        }
        Insert: {
          agent_id?: string | null
          booking_no?: string | null
          client_id: string
          closed_at?: string | null
          container_no?: string | null
          container_qty?: number | null
          container_type?: string | null
          created_at?: string
          eta?: string | null
          etd?: string | null
          id?: string
          inquiry_id?: string | null
          pod?: string | null
          pol?: string | null
          ref: string
          release_type?: string | null
          seal_no?: string | null
          shipping_line?: string | null
          stage?: string
          stuffing_date?: string | null
          supplier_id?: string | null
          vessel?: string | null
          voyage?: string | null
        }
        Update: {
          agent_id?: string | null
          booking_no?: string | null
          client_id?: string
          closed_at?: string | null
          container_no?: string | null
          container_qty?: number | null
          container_type?: string | null
          created_at?: string
          eta?: string | null
          etd?: string | null
          id?: string
          inquiry_id?: string | null
          pod?: string | null
          pol?: string | null
          ref?: string
          release_type?: string | null
          seal_no?: string | null
          shipping_line?: string | null
          stage?: string
          stuffing_date?: string | null
          supplier_id?: string | null
          vessel?: string | null
          voyage?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "shipments_agent_id_fkey"
            columns: ["agent_id"]
            isOneToOne: false
            referencedRelation: "agents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "shipments_client_id_fkey"
            columns: ["client_id"]
            isOneToOne: false
            referencedRelation: "clients"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "shipments_inquiry_id_fkey"
            columns: ["inquiry_id"]
            isOneToOne: false
            referencedRelation: "inquiries"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "shipments_supplier_id_fkey"
            columns: ["supplier_id"]
            isOneToOne: false
            referencedRelation: "suppliers"
            referencedColumns: ["id"]
          },
        ]
      }
      suggested_updates: {
        Row: {
          created_at: string
          email_id: string | null
          field: string
          id: string
          new_value: string | null
          old_value: string | null
          shipment_id: string
          status: string
        }
        Insert: {
          created_at?: string
          email_id?: string | null
          field: string
          id?: string
          new_value?: string | null
          old_value?: string | null
          shipment_id: string
          status?: string
        }
        Update: {
          created_at?: string
          email_id?: string | null
          field?: string
          id?: string
          new_value?: string | null
          old_value?: string | null
          shipment_id?: string
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "suggested_updates_email_id_fkey"
            columns: ["email_id"]
            isOneToOne: false
            referencedRelation: "email_messages"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "suggested_updates_shipment_id_fkey"
            columns: ["shipment_id"]
            isOneToOne: false
            referencedRelation: "shipments"
            referencedColumns: ["id"]
          },
        ]
      }
      suppliers: {
        Row: {
          city: string | null
          contact_name: string | null
          created_at: string
          email: string | null
          id: string
          name: string
          wechat: string | null
        }
        Insert: {
          city?: string | null
          contact_name?: string | null
          created_at?: string
          email?: string | null
          id?: string
          name: string
          wechat?: string | null
        }
        Update: {
          city?: string | null
          contact_name?: string | null
          created_at?: string
          email?: string | null
          id?: string
          name?: string
          wechat?: string | null
        }
        Relationships: []
      }
      templates: {
        Row: {
          body_template: string
          channel: string
          created_at: string
          id: string
          key: string
          name: string
          notes: string | null
          subject_template: string | null
        }
        Insert: {
          body_template: string
          channel: string
          created_at?: string
          id?: string
          key: string
          name: string
          notes?: string | null
          subject_template?: string | null
        }
        Update: {
          body_template?: string
          channel?: string
          created_at?: string
          id?: string
          key?: string
          name?: string
          notes?: string | null
          subject_template?: string | null
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends (DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never) = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends (PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never) = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
