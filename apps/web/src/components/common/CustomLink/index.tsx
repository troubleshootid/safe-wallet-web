import MUILink from '@mui/material/Link'
import type { LinkProps as MUILinkProps } from '@mui/material/Link/Link'
import type { LinkProps as NextLinkProps } from 'next/dist/client/link'
import NextLink from 'next/link'

const CustomLink: React.FC<
  React.PropsWithChildren<Omit<MUILinkProps, 'href'> & Pick<NextLinkProps, 'href' | 'as'>>
> = ({ href = '', as, children, ...other }) => {
  const isExternal = href.toString().startsWith('http')
  return (
    <NextLink href={href} as={as}>
      {/* @next-codemod-error This Link previously used the now removed `legacyBehavior` prop, and has a child that might not be an anchor. The codemod bailed out of lifting the child props to the Link. Check that the child component does not render an anchor, and potentially move the props manually to Link. */
      }
      <MUILink target={isExternal ? '_blank' : ''} rel="noreferrer" {...other}>
        {children}
      </MUILink>
    </NextLink>
  );
}

export default CustomLink
