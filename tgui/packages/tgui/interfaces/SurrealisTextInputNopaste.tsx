import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Section, Stack, TextArea } from 'tgui-core/components';
import { isEscape, KEY } from 'tgui-core/keys';
import type { BooleanLike } from 'tgui-core/react';

import { InputButtons } from './common/InputButtons';
import { Loader } from './common/Loader';
import { removeAllSkiplines, sanitizeMultiline } from './TextInputModal';

type TextInputData = {
  large_buttons: boolean;
  max_length: number;
  message: string;
  multiline: boolean;
  placeholder: string;
  timeout: number;
  title: string;
  spellcheck: BooleanLike;
  bigmodal?: boolean;
};

const pauseEvent = (event: any) => {
  if (event.stopPropagation) {
    event.stopPropagation();
  }
  if (event.preventDefault) {
    event.preventDefault();
  }
  event.cancelBubble = true;
  event.returnValue = false;
  return false;
};

export const SurrealisTextInputNopaste = () => {
  const { act, data } = useBackend<TextInputData>();
  const {
    large_buttons,
    max_length,
    message = '',
    multiline,
    placeholder = '',
    timeout,
    title,
    bigmodal,
  } = data;

  const [input, setInput] = useState(placeholder || '');

  const onType = (value: string) => {
    if (value === input) {
      return;
    }
    const sanitizedInput = multiline
      ? sanitizeMultiline(value)
      : removeAllSkiplines(value);
    setInput(sanitizedInput);
  };

  const visualMultiline = multiline || input.length >= 30;
  // Dynamically changes the window height based on the message.
  const dynamicHeight = message.length > 30 ? (message.length / 40) * 18 : 18;

  let windowHeight =
    135 +
    dynamicHeight +
    (visualMultiline ? 75 : 0) +
    (message.length && large_buttons ? 5 : 0);
  if (bigmodal) windowHeight = 425; // Override and just make a big modal for FT / OOC Notes
  const windowWidth = bigmodal ? 530 : 325;

  function handleKeyDown(event: React.KeyboardEvent<HTMLDivElement>) {
    if (event.key === KEY.Enter && (!visualMultiline || !event.shiftKey)) {
      act('submit', { entry: input });
    }
    if (isEscape(event.key)) {
      act('cancel');
    }
  }

  // gate for chastity hardmode prayer to prevent cheaters from copy pasting
  const handleBlockedInput = (event: React.SyntheticEvent) => {
    pauseEvent(event);
  };

  return (
    <Window title={title} width={windowWidth} height={windowHeight}>
      {timeout && <Loader value={timeout} />}
      <Window.Content onKeyDown={handleKeyDown}>
        <Section fill>
          <Stack fill vertical>
            <Stack.Item>
              <Box color="label">{message}</Box>
            </Stack.Item>
            <Stack.Item grow>
              {/* height:100% propagates the Stack.Item's grown height down to the TextArea */}
              <div
                style={{ height: '100%' }}
                onDrop={handleBlockedInput}
                onPaste={handleBlockedInput}
              >
                <TextArea
                  autoFocus
                  autoSelect
                  fluid
                  userMarkup={{ u: '_', i: '|', b: '+' }}
                  height={multiline || input.length >= 30 ? '100%' : '1.8rem'}
                  maxLength={max_length}
                  onEscape={() => act('cancel')}
                  onChange={onType}
                  placeholder="Type something..."
                  value={input}
                />
              </div>
            </Stack.Item>
            <Stack.Item>
              <InputButtons input={input} message={`${input.length}`} />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
