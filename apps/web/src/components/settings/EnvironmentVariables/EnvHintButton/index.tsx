import Link from 'next/link'
import { useRouter } from 'next/router'
import { SvgIcon, IconButton, Tooltip } from '@mui/material'
import { AppRoutes } from '@/config/routes'
import { useAppSelector } from '@/store'
import { isEnvInitialState } from '@/store/settingsSlice'
import css from './styles.module.css'
import AlertIcon from '@/public/images/common/alert.svg'
import useChainId from '@/hooks/useChainId'

const EnvHintButton = () => {
  const router = useRouter()
  const chainId = useChainId()
  const isInitialState = useAppSelector((state) => isEnvInitialState(state, chainId))

  if (isInitialState) {
    return null
  }

  return (
    <Link
      href={{ pathname: AppRoutes.settings.environmentVariables, query: router.query }}>
      {/* @next-codemod-error This Link previously used the now removed `legacyBehavior` prop, and has a child that might not be an anchor. The codemod bailed out of lifting the child props to the Link. Check that the child component does not render an anchor, and potentially move the props manually to Link. */
      }
      <Tooltip title="Default environment has been changed" placement="top" arrow>
        <IconButton
          className={css.button}
          size="small"
          color="warning"
          sx={{ justifySelf: 'flex-end', marginLeft: { sm: '0', md: 'auto' } }}
          disableRipple
        >
          <SvgIcon component={AlertIcon} inheritViewBox fontSize="small" />
        </IconButton>
      </Tooltip>
    </Link>
  );
}

export default EnvHintButton
