import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  Section,
  Stack,
  Tabs,
  Tooltip,
} from 'tgui-core/components';

type Rite = {
  id: string;
  name: string;
  desc: string | null;
  flavor: string | null;
  ascension: boolean;
  tier: number;
  tier_name: string;
  cooldown: string | null;
  tile_names: Record<string, string>;
  tile_icons: Record<string, string[]>;
};

type RiteState = {
  locked: string | null;
  cooldown_left: number;
  tile_states: Record<string, boolean>;
};

type HereticObjective = {
  tier: number;
  name: string;
  text: string;
  progress?: string | null;
  completed?: boolean;
  reward: HereticReward | null;
  path?: string | null;
};

type HereticReward = {
  gifts?: string[];
  paths?: Record<string, string[]>;
};

type HereticPath = {
  tier: number;
  path: string | null;
  branches: string[];
  branch_blurbs: Record<string, string>;
  current?: HereticObjective;
  history: HereticObjective[];
};

type SigilState = 'done' | 'current' | 'future' | 'forsaken';

type Sigil = {
  key: string;
  tier: number;
  branch: number | null;
  x: number;
  y: number;
  state: SigilState;
  objective?: HereticObjective;
};

type Data = {
  patron: string;
  theme: string;
  rune_name: string;
  rune_icon: string;
  tiles: Record<string, number>;
  rites: Rite[];
  ritualism: string;
  performing: boolean;
  rite_states: Record<string, RiteState>;
  heretic: HereticPath | null;
};

const HERETIC_TAB = 'heretic_path';

export const SurrealisRitualMenu = () => {
  const { data } = useBackend<Data>();
  const { heretic } = data;
  const [page, setPage] = useState('rites');
  const onPath = !!heretic && page === HERETIC_TAB;

  return (
    <Window width={800} height={720} theme={data.theme}>
      <Window.Content>
        <Stack fill vertical>
          {heretic ? (
            <Stack.Item>
              <Tabs fluid>
                <Tabs.Tab
                  selected={!onPath}
                  onClick={() => setPage('rites')}
                  icon="book"
                >
                  Rituals
                </Tabs.Tab>
                <Tabs.Tab
                  selected={onPath}
                  onClick={() => setPage(HERETIC_TAB)}
                  icon="eye"
                >
                  My Path
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
          ) : null}
          <Stack.Item grow>
            {onPath && heretic ? (
              <HereticDetails heretic={heretic} />
            ) : (
              <RitesPage />
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const RitesPage = () => {
  const { data } = useBackend<Data>();
  const { patron, rites, ritualism, rite_states } = data;
  const [viewing, setViewing] = useState(rites[0]?.id ?? '');
  const viewedRite = rites.find((rite) => rite.id === viewing);

  return (
    <Stack fill>
      <Stack.Item basis="35%">
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              <Box bold>{patron}</Box>
              <Box color="label">Ritualism: {ritualism}</Box>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              <Tabs vertical>
                {rites.map((rite) => {
                  const locked = rite_states[rite.id]?.locked;
                  return (
                    <Tabs.Tab
                      key={rite.id}
                      selected={viewing === rite.id}
                      onClick={() => setViewing(rite.id)}
                      className={locked ? 'RiteList__rite--locked' : undefined}
                      leftSlot={
                        <Box className="RiteList__mark">
                          {rite.ascension ? 'ᛦ' : ''}
                        </Box>
                      }
                      rightSlot={
                        <>
                          {rite.tier > 0 ? (
                            <Box inline className="RiteList__tier">
                              {rite.tier_name}
                            </Box>
                          ) : null}
                          {locked ? <Icon name="lock" ml={0.5} /> : null}
                        </>
                      }
                    >
                      {rite.name}
                    </Tabs.Tab>
                  );
                })}
              </Tabs>
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item grow>
        {viewedRite ? (
          <RiteDetails rite={viewedRite} />
        ) : (
          <Section fill title="Not Selected">
            Select a rite from the left pane.
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};

const MAX_TIER = 5;
const FORK_TIER = 3;
const VELLUM_WIDTH = 700;
const VELLUM_HEIGHT = 250;
const SIGIL_DRIFT = [4, -12, 10, -6, 8, -10];

const chartSigils = (heretic: HereticPath): Sigil[] => {
  const { branches, history, current, tier, path } = heretic;
  const chosen = path ? branches.indexOf(path) : -1;
  const stars: Sigil[] = [];
  for (let starTier = 0; starTier <= MAX_TIER; starTier++) {
    const forked = branches.length > 0 && starTier >= FORK_TIER;
    const rows = forked ? [0, 1] : [null];
    for (const branch of rows) {
      let state: SigilState = 'future';
      let objective: HereticObjective | undefined;
      if (branch !== null && chosen >= 0 && branch !== chosen) {
        state = 'forsaken';
      } else if (starTier < tier) {
        state = 'done';
        objective = history.find((past) => past.tier === starTier);
      } else if (starTier === tier && current) {
        state = 'current';
        objective = current;
      }
      let y = VELLUM_HEIGHT / 2;
      if (branch !== null) {
        y = branch === 0 ? 72 : VELLUM_HEIGHT - 64;
      }
      stars.push({
        key: `${starTier}-${branch ?? 'trunk'}`,
        tier: starTier,
        branch,
        x: 54 + starTier * ((VELLUM_WIDTH - 108) / MAX_TIER),
        y: y + SIGIL_DRIFT[starTier],
        state,
        objective,
      });
    }
  }
  return stars;
};

const HereticDetails = (props: { heretic: HereticPath }) => {
  const { heretic } = props;
  const stars = chartSigils(heretic);
  const startingSigil =
    stars.find((star) => star.state === 'current') ??
    [...stars].reverse().find((star) => star.state === 'done');
  const [selected, setSelected] = useState(startingSigil?.key);
  const selectedSigil = stars.find((star) => star.key === selected);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <SigilChart
          heretic={heretic}
          stars={stars}
          selected={selected}
          onSelect={setSelected}
        />
      </Stack.Item>
      <Stack.Item grow>
        <SigilReading heretic={heretic} star={selectedSigil} />
      </Stack.Item>
    </Stack>
  );
};

const SigilChart = (props: {
  heretic: HereticPath;
  stars: Sigil[];
  selected?: string;
  onSelect: (key: string) => void;
}) => {
  const { heretic, stars, selected, onSelect } = props;
  const { branches } = heretic;
  const lines: { from: Sigil; to: Sigil }[] = [];
  for (const star of stars) {
    if (star.tier === 0) {
      continue;
    }
    for (const previous of stars) {
      if (previous.tier !== star.tier - 1) {
        continue;
      }
      if (previous.branch === null || previous.branch === star.branch) {
        lines.push({ from: previous, to: star });
      }
    }
  }

  return (
    <Box className="HereticVellum">
      <svg
        className="HereticVellum__strokes"
        width={VELLUM_WIDTH}
        height={VELLUM_HEIGHT}
      >
        {lines.map(({ from, to }) => {
          const bend = to.tier % 2 ? 1 : -1;
          const midX = (from.x + to.x) / 2 + bend * 6;
          const midY = (from.y + to.y) / 2 - bend * 10;
          const stroke = `M${from.x} ${from.y} Q${midX} ${midY} ${to.x} ${to.y}`;
          const key = `${from.key}:${to.key}`;
          if (to.state === 'done' || to.state === 'current') {
            return (
              <g key={key}>
                <path
                  d={stroke}
                  fill="none"
                  stroke="#5a140d"
                  strokeWidth={5}
                  strokeLinecap="round"
                  opacity={0.55}
                />
                <path
                  d={stroke}
                  fill="none"
                  stroke="#7a1a12"
                  strokeWidth={2}
                  strokeLinecap="round"
                  opacity={0.8}
                />
              </g>
            );
          }
          if (to.state === 'forsaken') {
            return (
              <path
                key={key}
                d={stroke}
                fill="none"
                stroke="#5a3a2a"
                strokeWidth={1}
                strokeDasharray="2 6"
                opacity={0.15}
              />
            );
          }
          return (
            <path
              key={key}
              d={stroke}
              fill="none"
              stroke="#140f0c"
              strokeWidth={1.4}
              strokeDasharray="4 5"
              opacity={0.7}
            />
          );
        })}
      </svg>
      {branches.map((branch, index) => {
        const first = stars.find(
          (star) => star.tier === FORK_TIER && star.branch === index,
        );
        if (!first) {
          return null;
        }
        return (
          <Box
            key={branch}
            className={`HereticVellum__branch${first.state === 'forsaken' ? ' HereticVellum__branch--forsaken' : ''}`}
            style={{
              left: `${first.x - 24}px`,
              top: `${index === 0 ? first.y - 46 : first.y + 40}px`,
            }}
          >
            {branch}
          </Box>
        );
      })}
      {stars.map((star) => (
        <SigilMark
          key={star.key}
          star={star}
          selected={star.key === selected}
          onSelect={onSelect}
        />
      ))}
    </Box>
  );
};

const SigilMark = (props: {
  star: Sigil;
  selected: boolean;
  onSelect: (key: string) => void;
}) => {
  const { star, selected, onSelect } = props;
  const current = star.state === 'current';
  let className = `HereticVellum__sigil HereticVellum__sigil--${star.state}`;
  if (selected) {
    className += ' HereticVellum__sigil--selected';
  }

  return (
    <>
      <Box
        className={className}
        style={{ left: `${star.x}px`, top: `${star.y}px` }}
        onClick={() => onSelect(star.key)}
      >
        {star.state === 'future' ? '?' : 'ᛦ'}
      </Box>
      {star.objective ? (
        <Box
          className={`HereticVellum__label${current ? ' HereticVellum__label--current' : ''}`}
          style={{
            left: `${star.x}px`,
            top: `${star.y + (current ? 30 : 20)}px`,
          }}
          onClick={() => onSelect(star.key)}
        >
          {star.objective.name}
        </Box>
      ) : null}
    </>
  );
};

const SigilReading = (props: { heretic: HereticPath; star?: Sigil }) => {
  const { heretic, star } = props;
  if (!star) {
    return (
      <Section fill title="My Path">
        <Box italic>My patron has nothing more to ask of me, for now.</Box>
      </Section>
    );
  }
  const branchName =
    star.branch !== null ? heretic.branches[star.branch] : heretic.path;
  const title = `Tier ${star.tier}${branchName && star.tier >= FORK_TIER ? ` - ${branchName}` : ''}`;

  return (
    <Section fill scrollable title={title}>
      {star.state === 'forsaken' ? (
        <Box italic color="label">
          I did not walk this path.
        </Box>
      ) : null}
      {star.state === 'future' ? (
        <Box italic color="label">
          My patron has not yet revealed this to me.
        </Box>
      ) : null}
      {star.objective ? (
        <HereticObjectiveBox
          objective={star.objective}
          past={star.state === 'done'}
          blurbs={heretic.branch_blurbs}
        />
      ) : null}
      {star.state === 'current' ? (
        <Box mt={1} color="label">
          At each tier, my patron asks a deed of me. Once it is done, I return
          to any of Their runes and perform the Rite of Ascension.
        </Box>
      ) : null}
    </Section>
  );
};

const HereticObjectiveBox = (props: {
  objective: HereticObjective;
  past?: boolean;
  blurbs?: Record<string, string>;
}) => {
  const { objective, past, blurbs } = props;

  return (
    <Box>
      <Box bold>{objective.name}</Box>
      <Box>{objective.text}</Box>
      {!past && objective.progress ? (
        <Box mt={0.5}>
          {objective.progress.split(' | ').map((part, index) => {
            const [label, status] = part.split(' - ');
            return (
              <Box key={part} inline>
                {index > 0 ? ' | ' : ''}
                {status ? (
                  <>
                    {label} -{' '}
                    <Box inline color={status === 'COMPLETE' ? 'good' : 'bad'}>
                      {status}
                    </Box>
                  </>
                ) : (
                  part
                )}
              </Box>
            );
          })}
        </Box>
      ) : null}
      {!past ? (
        <Box color={objective.completed ? 'good' : 'average'}>
          {objective.completed
            ? "Done. I should return to my patron's rune."
            : 'Not yet done.'}
        </Box>
      ) : null}
      {objective.reward ? (
        <RewardBox
          reward={objective.reward}
          claimed={!!past}
          chosenPath={objective.path}
          blurbs={blurbs}
        />
      ) : null}
    </Box>
  );
};

const STAT_REWARD = /^[+-]\d+ [A-Z]{3}$/;

const RewardList = (props: { rewards: string[] }) => {
  const stats = props.rewards.filter((reward) => STAT_REWARD.test(reward));
  const gifts = props.rewards.filter((reward) => !STAT_REWARD.test(reward));

  return (
    <>
      {stats.length ? (
        <Box className="HereticReward__chips">
          {stats.map((stat) => (
            <Box key={stat} inline className="HereticReward__chip">
              {stat}
            </Box>
          ))}
        </Box>
      ) : null}
      {gifts.map((gift) => (
        <Box key={gift} className="HereticReward__gift">
          {gift}
        </Box>
      ))}
    </>
  );
};

const RewardStamp = (props: { forsaken?: boolean; small?: boolean }) => {
  const { forsaken, small } = props;
  let className = forsaken
    ? 'HereticReward__stamp HereticReward__stamp--forsaken'
    : 'HereticReward__stamp';
  if (small) {
    className += ' HereticReward__stamp--small';
  }
  return <Box className={className}>{forsaken ? 'FORSAKEN' : 'CLAIMED'}</Box>;
};

const RewardBox = (props: {
  reward: HereticReward;
  claimed: boolean;
  chosenPath?: string | null;
  blurbs?: Record<string, string>;
}) => {
  const { reward, claimed, chosenPath, blurbs } = props;
  const gifts = reward.gifts ?? [];
  const paths = reward.paths ?? {};
  const pathNames = Object.keys(paths);
  const forked = pathNames.length > 0;

  return (
    <Box className="HereticReward">
      <Box style={{ position: 'relative' }}>
        <Box className={claimed ? 'HereticReward__greyed' : undefined}>
          <Box className="HereticReward__heading">Reward</Box>
          <RewardList rewards={gifts} />
        </Box>
        {claimed && gifts.length ? <RewardStamp small={forked} /> : null}
      </Box>
      {forked ? (
        <>
          <Box
            className={`HereticReward__heading HereticReward__fork-heading${claimed ? ' HereticReward__greyed' : ''}`}
          >
            And a path of my choosing
          </Box>
          <Box className="HereticReward__fork">
            {pathNames.map((name) => {
              const forsaken = claimed && name !== chosenPath;
              let cardClass = 'HereticReward__card';
              if (claimed) {
                cardClass += forsaken
                  ? ' HereticReward__card--forsaken'
                  : ' HereticReward__greyed';
              }
              return (
                <Box key={name} style={{ position: 'relative' }}>
                  <Box className={cardClass}>
                    <Box className="HereticReward__card-title">{name}</Box>
                    {blurbs?.[name] ? (
                      <Box className="HereticReward__card-blurb">
                        {blurbs[name]}
                      </Box>
                    ) : null}
                    <RewardList rewards={paths[name]} />
                  </Box>
                  {claimed ? <RewardStamp forsaken={forsaken} small /> : null}
                </Box>
              );
            })}
          </Box>
        </>
      ) : null}
    </Box>
  );
};

const RiteDetails = (props: { rite: Rite }) => {
  const { rite } = props;
  const { act, data } = useBackend<Data>();
  const { performing, rite_states } = data;
  const state = rite_states[rite.id];
  const locked = state?.locked;
  const cooldownLeft = state?.cooldown_left ?? 0;
  const tileStates = state?.tile_states ?? {};
  const arrangementReady = Object.values(tileStates).every(Boolean);

  let invokeText = 'Invoke';
  if (performing) {
    invokeText = 'Performing...';
  } else if (locked) {
    invokeText = 'Locked';
  } else if (!arrangementReady) {
    invokeText = 'Missing components';
  }

  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Section fill scrollable title={rite.name}>
          <Box style={{ position: 'relative', minHeight: '100%' }}>
            <RiteBody rite={rite} tileStates={tileStates} />
            {locked ? (
              <LockOverlay reason={locked} cooldownLeft={cooldownLeft} />
            ) : null}
          </Box>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          textAlign="center"
          fontSize={1.3}
          disabled={!!locked || performing}
          color={
            !locked && !performing && arrangementReady ? 'good' : undefined
          }
          onClick={() => act('invoke', { rite: rite.id })}
          style={{ padding: '6px 0' }}
        >
          {invokeText}
        </Button>
      </Stack.Item>
    </Stack>
  );
};

const LockOverlay = (props: { reason: string; cooldownLeft: number }) => {
  const { reason, cooldownLeft } = props;
  return (
    <Box
      style={{
        position: 'absolute',
        inset: 0,
        background: 'rgba(0, 0, 0, 0.6)',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        textAlign: 'center',
        padding: '16px',
      }}
    >
      <Icon name="lock" size={3} mb={1} />
      {cooldownLeft > 0 ? (
        <>
          <Box bold fontSize={1.2}>
            Recovering
          </Box>
          <CooldownTimer deciseconds={cooldownLeft} />
        </>
      ) : (
        <Box bold style={{ whiteSpace: 'pre-line' }}>
          {reason}
        </Box>
      )}
    </Box>
  );
};

const CooldownTimer = (props: { deciseconds: number }) => {
  const { deciseconds } = props;
  const [receivedAt, setReceivedAt] = useState(Date.now());
  const [now, setNow] = useState(Date.now());

  useEffect(() => {
    setReceivedAt(Date.now());
  }, [deciseconds]);

  useEffect(() => {
    const interval = setInterval(() => setNow(Date.now()), 1000);
    return () => clearInterval(interval);
  }, []);

  const totalSeconds = Math.max(
    0,
    Math.ceil(deciseconds / 10 - (now - receivedAt) / 1000),
  );
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;

  return (
    <Box fontSize={2} mt={0.5}>
      {minutes}:{seconds.toString().padStart(2, '0')}
    </Box>
  );
};

const RiteBody = (props: {
  rite: Rite;
  tileStates: Record<string, boolean>;
}) => {
  const { rite, tileStates } = props;
  const tiered = rite.tier > 0;

  return (
    <Box>
      {rite.flavor ? (
        <Box className="RiteText__flavor">{rite.flavor}</Box>
      ) : null}
      {tiered || rite.cooldown ? (
        <Box className="RiteText__requirements">
          {tiered ? `${rite.tier_name} Ritualism` : null}
          {tiered && rite.cooldown ? <> &middot; </> : null}
          {rite.cooldown ? `${rite.cooldown} cooldown` : null}
        </Box>
      ) : null}
      <Box className="RiteText__arrangement">
        <RuneBoard rite={rite} tileStates={tileStates} />
        <Box className="RiteText__side">
          <ComponentList rite={rite} tileStates={tileStates} />
          {rite.desc ? (
            <Box className="RiteText__explanation">{rite.desc}</Box>
          ) : null}
        </Box>
      </Box>
    </Box>
  );
};

const useIconFrame = () => {
  const [frame, setFrame] = useState(0);
  useEffect(() => {
    const interval = setInterval(() => setFrame((last) => last + 1), 1000);
    return () => clearInterval(interval);
  }, []);
  return frame;
};

const ComponentList = (props: {
  rite: Rite;
  tileStates: Record<string, boolean>;
}) => {
  const { rite, tileStates } = props;
  const frame = useIconFrame();
  const components: Record<
    string,
    { icons: string[]; have: number; total: number }
  > = {};
  for (const tile of Object.keys(rite.tile_names)) {
    const name = rite.tile_names[tile];
    components[name] ??= {
      icons: rite.tile_icons[tile] ?? [],
      have: 0,
      total: 0,
    };
    components[name].total++;
    if (tileStates[tile]) {
      components[name].have++;
    }
  }
  const names = Object.keys(components);
  if (!names.length) {
    return null;
  }

  return (
    <Box>
      <Box className="RiteText__heading">Components</Box>
      {names.map((name) => {
        const { icons, have, total } = components[name];
        const done = have === total;
        return (
          <Box key={name} className="ComponentList__row">
            <Box className="ComponentList__icon">
              {icons.length ? (
                <img
                  alt=""
                  src={`data:image/png;base64,${icons[frame % icons.length]}`}
                />
              ) : null}
            </Box>
            <Box className="ComponentList__name">{name}</Box>
            <Box color={done ? 'good' : 'bad'}>
              {done ? '✓' : `${have} / ${total}`}
            </Box>
          </Box>
        );
      })}
    </Box>
  );
};

const RUNE_TILE = 80;
const RUNE_BOARD = RUNE_TILE * 3;
const RUNE_CENTER = RUNE_BOARD / 2;

const runeSpot = (index: number) => ({
  x: RUNE_TILE / 2 + (index % 3) * RUNE_TILE,
  y: RUNE_TILE / 2 + Math.floor(index / 3) * RUNE_TILE,
});

const ChalkCircle = () => {
  const spots = Array.from({ length: 9 }, (_, index) => runeSpot(index));
  const corners = [spots[0], spots[2], spots[8], spots[6]];
  const edges = [spots[1], spots[5], spots[7], spots[3]];
  const points = (list: { x: number; y: number }[]) =>
    list.map((spot) => `${spot.x},${spot.y}`).join(' ');
  const ticks = Array.from({ length: 24 }, (_, index) => {
    const angle = (index * 15 * Math.PI) / 180;
    const inner = index % 3 === 0 ? 100 : 104;
    return {
      x1: RUNE_CENTER + 108 * Math.cos(angle),
      y1: RUNE_CENTER + 108 * Math.sin(angle),
      x2: RUNE_CENTER + inner * Math.cos(angle),
      y2: RUNE_CENTER + inner * Math.sin(angle),
    };
  });

  return (
    <svg
      className="RuneBoard__circle"
      width={RUNE_BOARD}
      height={RUNE_BOARD}
      viewBox={`0 0 ${RUNE_BOARD} ${RUNE_BOARD}`}
    >
      <g fill="none" stroke="#d8d1cc" strokeLinecap="round">
        <circle
          cx={RUNE_CENTER}
          cy={RUNE_CENTER}
          r={114}
          strokeWidth={2.5}
          opacity={0.9}
        />
        <circle
          cx={RUNE_CENTER}
          cy={RUNE_CENTER}
          r={108}
          stroke="#b6b4b3"
          strokeWidth={1.5}
          opacity={0.75}
        />
        <g stroke="#b6b4b3" strokeWidth={1.5} opacity={0.7}>
          {ticks.map((tick, index) => (
            <line key={index} {...tick} />
          ))}
        </g>
        <polygon
          points={points(corners)}
          stroke="#a19891"
          strokeWidth={1.5}
          opacity={0.5}
        />
        <polygon
          points={points(edges)}
          stroke="#a19891"
          strokeWidth={1.5}
          opacity={0.5}
        />
        <circle
          cx={RUNE_CENTER}
          cy={RUNE_CENTER}
          r={56}
          strokeWidth={2}
          opacity={0.7}
        />
        {spots.map((spot, index) =>
          index === 4 ? null : (
            <circle
              key={index}
              cx={spot.x}
              cy={spot.y}
              r={22}
              stroke="#b6b4b3"
              strokeWidth={1.5}
              opacity={0.45}
            />
          ),
        )}
      </g>
    </svg>
  );
};

const RuneBoard = (props: {
  rite: Rite;
  tileStates: Record<string, boolean>;
}) => {
  const { rite, tileStates } = props;
  const { data } = useBackend<Data>();
  const { rune_icon } = data;
  const tileKeys = Object.keys(data.tiles);
  const frame = useIconFrame();

  return (
    <Box className="RuneBoard">
      <ChalkCircle />
      <img
        alt=""
        className="RuneBoard__rune"
        src={`data:image/png;base64,${rune_icon}`}
      />
      {tileKeys.map((tile, index) => {
        const needed = rite.tile_names[tile];
        const icons = rite.tile_icons[tile] ?? [];
        if (!needed || !icons.length) {
          return null;
        }
        const placed = tileStates[tile];
        const spot = runeSpot(index);
        return (
          <Tooltip key={tile} content={needed}>
            <Box
              className={`RuneBoard__item RuneBoard__item--${placed ? 'placed' : 'missing'}`}
              style={{ left: `${spot.x}px`, top: `${spot.y}px` }}
            >
              <img
                alt=""
                src={`data:image/png;base64,${icons[frame % icons.length]}`}
              />
            </Box>
          </Tooltip>
        );
      })}
    </Box>
  );
};
