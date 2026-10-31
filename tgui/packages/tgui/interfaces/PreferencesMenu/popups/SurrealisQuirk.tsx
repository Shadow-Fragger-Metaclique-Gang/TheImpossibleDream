import { PrefPopupGuard } from 'pm/components';
import {
  type ConstantData,
  type ConstantQuirk,
  useConstantPrefs,
} from 'pm/constant_data';
import type { Path } from 'pm/data';
import { type PopupData, usePopupBackend } from 'pm/popups';
import { useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { useFuzzySearch } from 'tgui-core/fuzzysearch';
import type { BooleanLike } from 'tgui-core/react';

export type SurrealisConstantQuirk = ConstantQuirk & {
  point_cost: number;
  drawback: BooleanLike;
  warning_text: string | null;
  incompatible: string[];
};

export type SurrealisQuirkPoints = {
  earned: number;
  spent: number;
  remaining: number;
  collateral: number;
};

type QuirkAvailability = {
  path: Path;
  unavailable: string | null;
};

type SurrealisQuirkPopupData = {
  quirks: Path[];
  quirk_availability: QuirkAvailability[];
  points: SurrealisQuirkPoints;
  malodorous_scent: string;
} & PopupData;

export const getQuirkTone = (quirk: {
  point_cost: number;
  drawback: BooleanLike;
}) => {
  if (quirk.drawback) {
    return { background: '#7a1616', hover: '#5e1010', text: '#f6dcdc' };
  }
  if (quirk.point_cost > 0) {
    return { background: '#2c5a2c', hover: '#224822', text: '#e2f2e2' };
  }
  return { background: '#cfc6c4', hover: '#b3aaa8', text: '#1a1010' };
};

export const formatQPoints = (points: number) =>
  `${points} Q-Point${points === 1 ? '' : 's'}`;

export const compareQuirks = (
  a: { name: string; point_cost: number; drawback: BooleanLike },
  b: { name: string; point_cost: number; drawback: BooleanLike },
) => {
  if (!!a.drawback !== !!b.drawback) {
    return a.drawback ? 1 : -1;
  }
  if (a.point_cost !== b.point_cost) {
    return b.point_cost - a.point_cost;
  }
  return a.name.localeCompare(b.name);
};

export const PopupSurrealisQuirk = () => {
  const [constantData] = useConstantPrefs();
  const { data } = usePopupBackend<SurrealisQuirkPopupData>();
  const { popup_data_ready } = data;

  return (
    <PrefPopupGuard
      title="Selecting Quirks"
      disableScroll
      loadingScreenText="Quirks Loading..."
      width="80vw"
      height="80vh"
      dependencies={[constantData, popup_data_ready]}
    >
      <PopupSurrealisQuirkInner constantData={constantData!} />
    </PrefPopupGuard>
  );
};

const StatDisplay = (props: { children: React.ReactNode }) => {
  return (
    <Box
      backgroundColor="#897472"
      bold
      color="black"
      fontSize="1.2em"
      px={3}
      py={0.5}
    >
      {props.children}
    </Box>
  );
};

type QuirkEntry = {
  path: Path;
  quirk: SurrealisConstantQuirk;
  unavailable: string | null;
};

const PopupSurrealisQuirkInner = (props: { constantData: ConstantData }) => {
  const { constantData } = props;
  const { act, data } = usePopupBackend<SurrealisQuirkPopupData>();
  const { quirks, quirk_availability, points, malodorous_scent } = data;
  const constantQuirks = constantData.quirks as Record<
    Path,
    SurrealisConstantQuirk
  >;

  const entries: QuirkEntry[] = quirk_availability
    .filter((a) => constantQuirks[a.path])
    .map((a) => ({
      path: a.path,
      quirk: constantQuirks[a.path],
      unavailable: a.unavailable,
    }))
    .sort((a, b) => compareQuirks(a.quirk, b.quirk));

  const available = entries.filter((e) => !quirks.includes(e.path));
  const current = entries.filter((e) => quirks.includes(e.path));

  const { query, setQuery, results } = useFuzzySearch({
    getSearchString: (e: QuirkEntry) => e.quirk.name,
    searchArray: available,
  });

  return (
    <Stack fill p={1}>
      <Stack.Item basis="50%">
        <Stack vertical fill align="center">
          <Stack.Item>
            <Box fontSize="1.3em">Q-Points Earned</Box>
          </Stack.Item>
          <Stack.Item>
            <StatDisplay>{points.earned}</StatDisplay>
          </Stack.Item>
          <Stack.Item>
            <Box as="b" fontSize="1.6em">
              Available Quirks
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Input
              placeholder="Search quirks..."
              width="200px"
              value={query}
              onChange={setQuery}
            />
          </Stack.Item>
          <Stack.Item grow width="100%">
            <Section fill scrollable>
              {(query.length ? results : available).map((entry) => (
                <QuirkCard
                  key={entry.path}
                  entry={entry}
                  onClick={() => {
                    if (entry.unavailable) {
                      return;
                    }
                    act('select_quirk', { quirk: entry.path });
                  }}
                />
              ))}
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>

      <Stack.Item align="center">
        <Icon name="exchange-alt" size={1.5} ml={2} mr={2} />
      </Stack.Item>

      <Stack.Item basis="50%">
        <Stack vertical fill align="center">
          <Stack.Item>
            <Box fontSize="1.3em">Q-Points Remaining</Box>
          </Stack.Item>
          <Stack.Item>
            <StatDisplay>{points.remaining}</StatDisplay>
          </Stack.Item>
          <Stack.Item>
            <Box as="b" fontSize="1.6em">
              Current Quirks
            </Box>
          </Stack.Item>
          <Stack.Item textAlign="center">
            <Box color={points.remaining < 0 ? 'bad' : 'good'}>
              Points Available: {points.remaining}
              {points.collateral ? ` (${points.collateral} TRIUMPHS)` : ''}
            </Box>
            <Box fontSize={0.8}>
              Quirk points (Q-Points) are granted by taking vices and can be
              spent on quirks.
              <br />
              Anything points can't afford will be purchased with TRIUMPH at 2
              TRI per 1 point.
              <br />
              Leftover quirk points will be converted 1-to-1 into TRIUMPH at the
              end of a round so long as you survived.
            </Box>
          </Stack.Item>
          <Stack.Item grow width="100%">
            <Section fill scrollable>
              {current.map((entry) => (
                <QuirkCard
                  key={entry.path}
                  entry={entry}
                  onClick={() => act('remove_quirk', { quirk: entry.path })}
                >
                  {entry.path === '/datum/quirk/malodorous' ? (
                    <Stack align="center" mt={0.5}>
                      <Stack.Item grow color="#48c75a">
                        They reek of {malodorous_scent || 'an unusual scent'}.
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="cog"
                          onClick={(e: React.MouseEvent) => {
                            e.stopPropagation();
                            act('malodorous_scent');
                          }}
                        >
                          Customize
                        </Button>
                      </Stack.Item>
                    </Stack>
                  ) : null}
                </QuirkCard>
              ))}
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const QuirkCard = (props: {
  entry: QuirkEntry;
  onClick: () => void;
  children?: React.ReactNode;
}) => {
  const { entry, onClick, children } = props;
  const { quirk, unavailable } = entry;
  const [hovered, setHovered] = useState(false);
  const tone = getQuirkTone(quirk);

  const card = (
    <Box
      style={{
        cursor: unavailable ? 'not-allowed' : 'pointer',
        opacity: unavailable ? 0.55 : 1,
        borderBottom: '1px solid #511111',
        backgroundColor: hovered ? '#1e0b0b' : '#0d0606',
      }}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      onClick={onClick}
    >
      <Stack fill g={0}>
        <Stack.Item grow ml={0} style={{ minWidth: '0%' }}>
          <Stack vertical fill g={0}>
            <Stack.Item
              style={{
                borderBottom: '1px solid black',
                padding: '2px 6px',
                backgroundColor: hovered ? tone.hover : tone.background,
                color: tone.text,
              }}
            >
              <Stack fill style={{ fontSize: '1.2em' }}>
                <Stack.Item grow basis="content">
                  <b>{quirk.name}</b>
                </Stack.Item>
                <Stack.Item>
                  <b>{formatQPoints(quirk.point_cost)}</b>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item style={{ padding: '3px 6px' }}>
              <Box dangerouslySetInnerHTML={{ __html: quirk.desc }} />
              {quirk.mechdesc ? (
                <Box
                  italic
                  color="#f1d669"
                  mt={0.5}
                  dangerouslySetInnerHTML={{ __html: quirk.mechdesc }}
                />
              ) : null}
              {quirk.warning_text ? (
                <Box
                  color="average"
                  mt={0.5}
                  dangerouslySetInnerHTML={{ __html: quirk.warning_text }}
                />
              ) : null}
              {quirk.incompatible.length ? (
                <Box mt={0.5} fontSize={0.9} color="bad">
                  Incompatible with: {quirk.incompatible.join(', ')}
                </Box>
              ) : null}
              {unavailable ? (
                <Box color="bad" mt={0.5}>
                  {unavailable}
                </Box>
              ) : null}
              {children}
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );

  if (unavailable) {
    return <Tooltip content={unavailable}>{card}</Tooltip>;
  }
  return card;
};
