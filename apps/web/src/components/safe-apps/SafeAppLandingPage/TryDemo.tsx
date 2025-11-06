import { Box, Button, Typography } from '@mui/material'
import { CTA_HEIGHT, CTA_BUTTON_WIDTH } from '@/components/safe-apps/SafeAppLandingPage/constants'
import Link from 'next/link'
import type { LinkProps } from 'next/link'
import DemoAppSVG from '@/public/images/apps/apps-demo.svg'

type Props = {
  demoUrl: LinkProps['href']
  onClick(): void
}

const TryDemo = ({ demoUrl, onClick }: Props) => (
  <Box display="flex" flexDirection="column" alignItems="center" justifyContent="space-between" height={CTA_HEIGHT}>
    <Typography variant="h5" fontWeight={700}>
      Try the Safe App before using it
    </Typography>
    <DemoAppSVG alt="An icon of a internet browser" />
    <Link href={demoUrl}>
      {/* @next-codemod-error This Link previously used the now removed `legacyBehavior` prop, and has a child that might not be an anchor. The codemod bailed out of lifting the child props to the Link. Check that the child component does not render an anchor, and potentially move the props manually to Link. */
      }
      <Button variant="outlined" sx={{ width: CTA_BUTTON_WIDTH }} onClick={onClick}>
        Try demo
      </Button>
    </Link>
  </Box>
)

export { TryDemo }
