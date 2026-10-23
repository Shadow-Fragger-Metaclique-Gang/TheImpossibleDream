// [SURREALIS-ADD] - MERCENARY_STATUE
import { LabeledGridList } from 'pm/components';
import { useBackendStrict } from 'tgui/backend';
import { Box, Button, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type StatuePrefsData = {
  statue_merc_message: string;
  statue_adv_optin: BooleanLike;
  statue_adv_message: string;
  statue_wretch_nom: string;
  statue_wretch_message: string;
};

export const StatueMercenarySection = () => {
  const { act, data } = useBackendStrict<StatuePrefsData>();
  return (
    <Section title="Mercenary Statue - Mercenaries">
      <Box mb={1}>
        Mercenaries are always entered on the Mercenary statue when they join
        the round. These settings only change how I am listed.
      </Box>
      <LabeledGridList>
        <LabeledGridList.Item label="Description">
          <Button
            fluid
            ellipsis
            tooltip={data.statue_merc_message || 'Unset'}
            onClick={() => act('statue_merc_message')}
          >
            {data.statue_merc_message || 'Unset'}
          </Button>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Section>
  );
};

export const StatueAdventurerSection = () => {
  const { act, data } = useBackendStrict<StatuePrefsData>();
  return (
    <Section title="Mercenary Statue - Adventurers">
      <Box mb={1}>
        Adventurers may opt in to being entered on the Mercenary statue's
        Adventurer roster when they join the round.
      </Box>
      <LabeledGridList>
        <LabeledGridList.Item label="Auto-post on Join">
          <Button.Checkbox
            fluid
            checked={!!data.statue_adv_optin}
            onClick={() => act('statue_adv_optin')}
          >
            {data.statue_adv_optin ? 'Enabled' : 'Disabled'}
          </Button.Checkbox>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Description">
          <Button
            fluid
            ellipsis
            tooltip={data.statue_adv_message || 'Unset'}
            onClick={() => act('statue_adv_message')}
          >
            {data.statue_adv_message || 'Unset'}
          </Button>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Section>
  );
};

export const StatueWretchSection = () => {
  const { act, data } = useBackendStrict<StatuePrefsData>();
  return (
    <Section title="Mercenary Statue - Wretches">
      <Box mb={1}>
        Wretches are always entered on the Wretch roster of the Mercenary statue
        when they join the round. These settings only change how I am listed.
        Leaving the name empty gives me one based on my class.
      </Box>
      <LabeledGridList>
        <LabeledGridList.Item label="Nom de Guerre">
          <Button
            fluid
            ellipsis
            tooltip={data.statue_wretch_nom || 'Assigned by class'}
            onClick={() => act('statue_wretch_nom')}
          >
            {data.statue_wretch_nom || 'Assigned by class'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Description">
          <Button
            fluid
            ellipsis
            tooltip={data.statue_wretch_message || 'Unset'}
            onClick={() => act('statue_wretch_message')}
          >
            {data.statue_wretch_message || 'Unset'}
          </Button>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Section>
  );
};
// [/SURREALIS-ADD]
