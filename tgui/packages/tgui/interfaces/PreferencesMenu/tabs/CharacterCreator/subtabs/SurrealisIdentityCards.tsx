import { LabeledGridList } from 'pm/components';
import { useConstantPrefs } from 'pm/constant_data';
import type { Path } from 'pm/data';
import type { SurrealisConstantCharflaw } from 'pm/popups/SurrealisCharflaw';
import {
  compareQuirks,
  formatQPoints,
  getQuirkTone,
  type SurrealisQuirkPoints,
} from 'pm/popups/SurrealisQuirk';
import { usePopupId } from 'pm/popups';
import type { IdentityData } from 'pm/tabs/CharacterCreator/data';
import { useBackendStrict } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type SurrealisQuirkEntry = {
  path: Path;
  name: string;
  point_cost: number;
  drawback: BooleanLike;
  spawn_error: string | null;
};

type SurrealisIdentityData = {
  quirks: SurrealisQuirkEntry[];
  quirk_points: SurrealisQuirkPoints;
};

export const SurrealisIdentityCardQuirks = () => {
  const { data } = useBackendStrict<SurrealisIdentityData>();
  const { quirks, quirk_points } = data;
  const [, setPopupId] = usePopupId();

  return (
    <Section
      title="Quirks"
      className="PreferencesMenu__Section__Quirks"
      buttons={
        <Box color={quirk_points.remaining < 0 ? 'bad' : 'good'}>
          Points Available: {quirk_points.remaining}
          {quirk_points.collateral
            ? ` (${quirk_points.collateral} TRIUMPHS)`
            : ''}
        </Box>
      }
    >
      <Stack vertical>
        {[...quirks].sort(compareQuirks).map((quirk) => {
          const tone = getQuirkTone(quirk);
          return (
            <Stack.Item key={quirk.path}>
              <Button
                fluid
                style={{ backgroundColor: tone.background, color: tone.text }}
                tooltip={
                  quirk.spawn_error
                    ? `This quirk will not be applied on spawn: ${quirk.spawn_error}`
                    : null
                }
                onClick={() => setPopupId('Quirk', { id: 1 })}
              >
                <Stack>
                  <Stack.Item grow>
                    {quirk.name}
                    {quirk.spawn_error ? ' (!)' : null}
                  </Stack.Item>
                  <Stack.Item>{formatQPoints(quirk.point_cost)}</Stack.Item>
                </Stack>
              </Button>
            </Stack.Item>
          );
        })}
        <Stack.Item>
          <Button
            fluid
            icon="bars"
            ml={4}
            onClick={() => setPopupId('Quirk', { id: 1 })}
          >
            Open Menu
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const SurrealisIdentityCardVices = () => {
  const { act, data } = useBackendStrict<IdentityData>();
  const { charflaws, has_averse, averse_chosen_faction } = data;
  const [constantData] = useConstantPrefs();
  const [, setPopupId] = usePopupId();
  const constantCharflaws = constantData?.charflaws as
    | Record<Path, SurrealisConstantCharflaw>
    | undefined;

  return (
    <Section title="Vices" className="PreferencesMenu__Section__Vices">
      {charflaws.map((flaw, index) => (
        <Button
          key={flaw.type}
          fluid
          onClick={() => act('toggle_charflaw', { flaw: flaw.type })}
        >
          <Stack>
            <Stack.Item grow>
              {flaw.name}
              {flaw.warning ? ' (Requires Extra Vice!)' : null}
            </Stack.Item>
            <Stack.Item>
              {index === 0
                ? 'first vice, no Q-Points'
                : `+${formatQPoints(constantCharflaws?.[flaw.type]?.point_value ?? 0)}`}
            </Stack.Item>
          </Stack>
        </Button>
      ))}
      <Button
        fluid
        icon="bars"
        ml={4}
        onClick={() => setPopupId('CharFlaw')}
      >
        Open Menu
      </Button>
      {has_averse ? (
        <LabeledGridList>
          <LabeledGridList.Item label="Loathed Group">
            <Button fluid mt={2} onClick={() => act('charflaw_averse_choice')}>
              {averse_chosen_faction}
            </Button>
          </LabeledGridList.Item>
        </LabeledGridList>
      ) : null}
    </Section>
  );
};
