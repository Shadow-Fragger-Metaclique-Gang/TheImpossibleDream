import {
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  titleStyle,
} from '../common/parchment';
import { starsIfIlliterate } from './util';

type Props = {
  motto: string;
  canRead: boolean;
  ordinanceActive: boolean;
  titheRatePct: number;
  tariffRatePct: number;
  churchTithePaid: number;
  tariffPaid: number;
  tariffEvaded: number;
  isProprietor: boolean;
  dodging: boolean;
};

export const Header = (props: Props) => {
  const {
    motto,
    canRead,
    ordinanceActive,
    titheRatePct,
    tariffRatePct,
    churchTithePaid,
    tariffPaid,
    tariffEvaded,
    isProprietor,
    dodging,
  } = props;

  return (
    <>
      <div style={titleStyle}>{starsIfIlliterate(motto, canRead)}</div>
      <div style={rulerStyle} />
      <div
        style={{
          display: 'flex',
          flexWrap: 'wrap',
          justifyContent: 'center',
          gap: '8px 18px',
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          marginBottom: '8px',
        }}
      >
        {ordinanceActive ? (
          <span style={{ color: SEAL_GREEN }}>
            {/* [SURREALIS-EDIT] - LORE */}
            {/* <b>Ordinance:</b> in force - {titheRatePct}% tithed unto the Church SURREALIS-EDIT - ORIGINAL */}
            <b>Ordinance:</b> in force - {titheRatePct}% tithed unto the Temple
            {/* [/SURREALIS-EDIT] */}
          </span>
        ) : (
          <span style={{ color: SEAL_RED }}>
            <b>Ordinance:</b> broken - {tariffRatePct}% Crown duty levied
          </span>
        )}
        {isProprietor && (
          <>
            <span style={{ color: INK_SOFT }}>
              {/* [SURREALIS-EDIT] - LORE */}
              {/* <b>Church tithed here:</b>{' '} SURREALIS-EDIT - ORIGINAL */}
              <b>Temple tithed here:</b>{' '}
              {/* [/SURREALIS-EDIT] */}
              <span style={{ color: SEAL_AMBER }}>{churchTithePaid}m</span>
            </span>
            <span style={{ color: INK_SOFT }}>
              <b>Crown duty paid:</b>{' '}
              <span style={{ color: INK }}>{tariffPaid}m</span>
            </span>
            {(tariffEvaded > 0 || dodging) && (
              <span style={{ color: SEAL_RED }}>
                <b>Duty dodged:</b> {tariffEvaded}m
                {dodging && ' (NOTAX active)'}
              </span>
            )}
          </>
        )}
        {!isProprietor && !ordinanceActive && (
          <span style={{ color: INK_FAINT }}>
            Prices include Crown import duty.
          </span>
        )}
      </div>
    </>
  );
};
