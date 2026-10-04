export interface SexAction {
  name: string;
  type: string;
  description: string;
  requires_grab: boolean;
}

export interface SexCategory {
  name: string;
  value: number;
}

export interface SexSessionData {
  // Static data
  speed_names: string[];
  force_names: string[];
  manual_arousal_names: string[];

  // Dynamic data
  title: string;
  doing_unto: string;
  current_action: string | null;
  speed: number;
  force: number;
  max_speed: number;
  max_force: number;
  has_penis: boolean;
  manual_arousal: number;
  do_until_finished: boolean;

  exposure_label: string;
  bottom_exposed: boolean;
  has_genitals: boolean;
  hide_pintle_visuals: boolean;
  freeuse: boolean;
  doing_subtly: boolean;

  knot_mode: 'top' | 'bottom' | null;
  do_knot_action: boolean;
  do_knot_action_as_bottom: boolean;

  // Arousal tracking
  arousal: number;
  frozen: boolean;
  can_freeze: boolean;

  // Action menu
  category: number;
  categories: SexCategory[];
  actions: SexAction[];
  can_perform: string[];
}
